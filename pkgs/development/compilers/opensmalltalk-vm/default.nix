{ stdenv
, lib
, fetchFromGitHub
, fetchurl
, alsa-lib
, coreutils
, file
, freetype
, gnugrep
, libpulseaudio
, libtool
, libuuid
, openssl
, pango
, pkg-config
, xorg
}:
let
  buildVM =
    {
      # VM-specific information, manually extracted from building/<platformDir>/<vmName>/build/mvm
      platformDir
    , vmName
    , scriptName
    , configureFlagsArray
    , configureFlags
    }:
    let
      src = fetchFromGitHub {
        owner = "OpenSmalltalk";
        repo = "opensmalltalk-vm";
        rev = "202206021410";
        hash = "sha256-QqElPiJuqD5svFjWrLz1zL0Tf+pHxQ2fPvkVRn2lyBI=";
      };
    in
    stdenv.mkDerivation {
      pname =
        let vmNameNoDots = builtins.replaceStrings [ "." ] [ "-" ] vmName;
        in "opensmalltalk-vm-${platformDir}-${vmNameNoDots}";
      version = src.rev;

      inherit src;

      postPatch =
        ''
          vmVersionFiles=$(sed -n 's/^versionfiles="\(.*\)"/\1/p' ./scripts/updateSCCSVersions)
          for vmVersionFile in $vmVersionFiles; do
            substituteInPlace "$vmVersionFile" \
              --replace "\$Date\$" "\$Date: Thu Jan 1 00:00:00 1970 +0000 \$" \
              --replace "\$URL\$" "\$URL: ${src.url} \$" \
              --replace "\$Rev\$" "\$Rev: ${src.rev} \$" \
              --replace "\$CommitHash\$" "\$CommitHash: 000000000000 \$"
          done
          patchShebangs --build ./building/${platformDir} scripts
          substituteInPlace ./platforms/unix/config/mkmf \
            --replace "/bin/rm" "rm"
          substituteInPlace ./platforms/unix/config/configure \
            --replace "/usr/bin/file" "file" \
            --replace "/usr/bin/pkg-config" "pkg-config" \
        '';

      preConfigure = ''
        cd building/${platformDir}/${vmName}/build
        # Exits with non-zero code if the check fails, counterintuitively
        ../../../../scripts/checkSCCSversion && exit 1
        cp ../plugins.int ../plugins.ext .
        configureFlagsArray=${configureFlagsArray}
      '';

      configureScript = "../../../../platforms/unix/config/configure";

      configureFlags = [ "--with-scriptname=${scriptName}" ] ++ configureFlags;

      buildFlags = [ "all" ];

      enableParallelBuilding = true;

      nativeBuildInputs = [
        file
        pkg-config
      ];

      buildInputs = [
        alsa-lib
        freetype
        libpulseaudio
        libtool
        libuuid
        openssl
        pango
        xorg.libX11
        xorg.libXrandr
      ];

      postInstall = ''
        rm "$out/squeak"
        cd "$out/bin"
        BIN="$(find ../lib -type f -name squeak)"
        for f in $(find . -type f); do
          rm "$f"
          ln -s "$BIN" "$f"
        done
      '';

      meta = {
        description = "Cross-platform virtual machine for Squeak, Pharo, Cuis, and Newspeak";
        mainProgram = scriptName;
        homepage = "https://opensmalltalk.org/";
        license = with lib.licenses; [ mit ];
        maintainers = with lib.maintainers; [ jakewaksbaum ];
        platforms = [ stdenv.targetPlatform.system ];
      };
    };

  vmsByPlatform = {
    "aarch64-linux" = {
      "squeak-cog-spur" = buildVM {
        platformDir = "linux64ARMv8";
        vmName = "squeak.cog.spur";
        scriptName = "squeak";
        configureFlagsArray = ''(
          CFLAGS="-DNDEBUG -DDEBUGVM=0 -DMUSL -D_GNU_SOURCE -DUSEEVDEV -DCOGMTVM=0 -DDUAL_MAPPED_CODE_ZONE=1"
          LIBS="-lrt"
        )'';
        configureFlags = [
          "--with-vmversion=5.0"
          "--with-src=src/spur64.cog"
          "--without-npsqueak"
          "--enable-fast-bitblt"
        ];
      };

      "squeak-stack-spur" = buildVM {
        platformDir = "linux64ARMv8";
        vmName = "squeak.stack.spur";
        scriptName = "squeak";
        configureFlagsArray = ''(
          CFLAGS="-DNDEBUG -DDEBUGVM=0 -DMUSL -D_GNU_SOURCE -DUSEEVDEV -D__ARM_ARCH_ISA_A64 -DARM64 -D__arm__ -D__arm64__ -D__aarch64__"
        )'';
        configureFlags = [
          "--with-vmversion=5.0"
          "--with-src=src/spur64.stack"
          "--disable-cogit"
          "--without-npsqueak"
        ];
      };
    };

    "x86_64-linux" = {
      "newspeak-cog-spur" = buildVM {
        platformDir = "linux64x64";
        vmName = "newspeak.cog.spur";
        scriptName = "newspeak";
        configureFlagsArray = ''(
          CFLAGS="-DNDEBUG -DDEBUGVM=0"
        )'';
        configureFlags = [
          "--with-vmversion=5.0"
          "--with-src=src/spur64.cog.newspeak"
          "--without-vm-display-fbdev"
          "--without-npsqueak"
        ];
      };

      "squeak-cog-spur" = buildVM {
        platformDir = "linux64x64";
        vmName = "squeak.cog.spur";
        scriptName = "squeak";
        configureFlagsArray = ''(
          CFLAGS="-DNDEBUG -DDEBUGVM=0 -DCOGMTVM=0"
        )'';
        configureFlags = [
          "--with-vmversion=5.0"
          "--with-src=src/spur64.cog"
          "--without-npsqueak"
        ];
      };
    };
  };

  platform = stdenv.targetPlatform.system;
in
  vmsByPlatform.${platform} or (throw (
    "Unsupported platform ${platform}: only the following platforms are supported: " +
    builtins.toString (builtins.attrNames vmsByPlatform)
  ))
