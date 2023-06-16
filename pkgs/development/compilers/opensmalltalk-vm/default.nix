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
  baseFunc = { vmName, platforms }:
    finalAttrs: {
      inherit vmName;
      pname = let
        vmNameNoDots =
          builtins.replaceStrings [ "." ] [ "-" ] finalAttrs.vmName;
      in "opensmalltalk-vm-${vmNameNoDots}";
      version = finalAttrs.src.rev;

      src = fetchFromGitHub {
        owner = "OpenSmalltalk";
        repo = "opensmalltalk-vm";
        rev = "202206021410";
        hash = "sha256-QqElPiJuqD5svFjWrLz1zL0Tf+pHxQ2fPvkVRn2lyBI=";
      };

      postPatch = ''
        vmVersionFiles=$(sed -n 's/^versionfiles="\(.*\)"/\1/p' ./scripts/updateSCCSVersions)
        for vmVersionFile in $vmVersionFiles; do
          substituteInPlace "$vmVersionFile" \
            --replace "\$Date\$" "\$Date: Thu Jan 1 00:00:00 1970 +0000 \$" \
            --replace "\$URL\$" "\$URL: ${finalAttrs.src.url} \$" \
            --replace "\$Rev\$" "\$Rev: ${finalAttrs.src.rev} \$" \
            --replace "\$CommitHash\$" "\$CommitHash: 000000000000 \$"
        done
        patchShebangs --build ./building/$platformDir scripts
        substituteInPlace ./platforms/unix/config/mkmf \
          --replace "/bin/rm" "rm"
        substituteInPlace ./platforms/unix/config/configure \
          --replace "/usr/bin/file" "file" \
          --replace "/usr/bin/pkg-config" "pkg-config" \
      '';

      preConfigure = ''
        cd building/$platformDir/$vmName/build
        # Exits with non-zero code if the check fails, counterintuitively
        ../../../../scripts/checkSCCSversion && exit 1
        cp ../plugins.int ../plugins.ext .
      '';

      configureScript = "../../../../platforms/unix/config/configure";

      CFLAGS = [ "-DNDEBUG" "-DDEBUGVM=0" ];

      configureFlags = [ "--with-scriptname=${finalAttrs.scriptName}" ];

      buildFlags = "all";

      enableParallelBuilding = true;

      nativeBuildInputs = [ file pkg-config ];

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
        description =
          "The cross-platform virtual machine for Squeak, Pharo, Cuis, and Newspeak.";
        mainProgram = finalAttrs.scriptName;
        homepage = "https://opensmalltalk.org/";
        license = with lib.licenses; [ mit ];
        maintainers = with lib.maintainers; [ jakewaksbaum ehmry ];
        inherit platforms;
      };
    };

  buildVM = { vmName, platforms }:
    stdenv.mkDerivation (final:
      let
        pkgFunc = platforms.${stdenv.targetPlatform.system} or (_: _: { });
        prev = baseFunc {
          inherit vmName;
          platforms = builtins.attrNames platforms;
        } final;
      in prev // pkgFunc final prev);

in {
  squeak-cog-spur = buildVM {
    vmName = "squeak.cog.spur";
    platforms = {
      aarch64-linux = (final: prev: {
        scriptName = "squeak";
        platformDir = "linux64ARMv8";
        CFLAGS = prev.CFLAGS ++ [
          "-DMUSL"
          "-D_GNU_SOURCE"
          "-DUSEEVDEV"
          "-DCOGMTVM=0"
          "-DDUAL_MAPPED_CODE_ZONE=1"
        ];
        LIBS = [ "-lrt" ];
        configureFlags = prev.configureFlags ++ [
          "--with-vmversion=5.0"
          "--with-src=src/spur64.cog"
          "--without-npsqueak"
          "--enable-fast-bitblt"
        ];
      });
      x86_64-linux = (final: prev: {
        vmName = "squeak.cog.spur";
        scriptName = "squeak";
        platformDir = "linux64x64";
        CFLAGS = prev.CFLAGS ++ [ "-DCOGMTVM=0" ];
        configureFlags = prev.configureFlags ++ [
          "--with-vmversion=5.0"
          "--with-src=src/spur64.cog"
          "--without-npsqueak"
        ];
      });
    };
  };

  squeak-stack-spur = buildVM {
    vmName = "squeak.stack.spur";
    platforms = {
      aarch64-linux = (final: prev: {
        scriptName = "squeak";
        platformDir = "linux64ARMv8";
        CFLAGS = prev.CFLAGS ++ [
          "-DMUSL"
          "-D_GNU_SOURCE"
          "-DUSEEVDEV"
          "-D__ARM_ARCH_ISA_A64"
          "-DARM64"
          "-D__arm__"
          "-D__arm64__"
          "-D__aarch64__"
        ];
        configureFlags = prev.configureFlags ++ [
          "--with-vmversion=5.0"
          "--with-src=src/spur64.stack"
          "--disable-cogit"
          "--without-npsqueak"
        ];
      });
    };
  };

  newspeak-cog-spur = buildVM {
    vmName = "newspeak.cog.spur";
    platforms = {
      x86_64-linux = (final: prev: {
        scriptName = "newspeak";
        platformDir = "linux64x64";
        configureFlags = prev.configureFlags ++ [
          "--with-vmversion=5.0"
          "--with-src=src/spur64.cog.newspeak"
          "--without-vm-display-fbdev"
          "--without-npsqueak"
        ];
      });
    };
  };

}
