{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchurl,
  alsa-lib,
  coreutils,
  file,
  freetype,
  gnugrep,
  libpulseaudio,
  libtool,
  libuuid,
  openssl,
  pango,
  pkg-config,
  xorg,
  libGL,
}:
let
  buildVM =
    {
      # VM-specific information, manually extracted from building/<platformDir>/<vmName>/build/mvm
      platformDir,
      vmName,
      scriptName,
      configureFlagsArray,
      configureFlags,
    }:
    let
      src = fetchFromGitHub {
        owner = "OpenSmalltalk";
        repo = "opensmalltalk-vm";
        rev = "202312181441";
        hash = "sha256-j8fVL8072ccdaRyW5sPDcYXxMcIZIvSFJ+4Q1+41ey0=";
      };
    in
    stdenv.mkDerivation {
      pname =
        let
          vmNameNoDots = builtins.replaceStrings [ "." ] [ "-" ] vmName;
        in
        "opensmalltalk-vm-${platformDir}-${vmNameNoDots}";
      version = src.rev;

      inherit src;

      # Fixes build errors triggered by the format-security compiler flag
      # and caused by passing non-literals as the first argument to printf.
      patches = [ ./printOptionStrings.patch ];

      postPatch = ''
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

      buildFlags = [
        "getversion"
        "all"
      ];

      enableParallelBuilding = false;

      nativeBuildInputs = [
        file
        pkg-config
      ];

      buildInputs = [
        alsa-lib
        freetype
        libGL
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
        description = "Cross-platform virtual machine for Squeak, Pharo, and Cuis";
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
        configureFlagsArray = ''
          (
            CFLAGS="-fpermissive -DNDEBUG -DDEBUGVM=0 -DMUSL -D_GNU_SOURCE -DUSEEVDEV -DCOGMTVM=0 -DDUAL_MAPPED_CODE_ZONE=1"
            LIBS="-lrt"
          )
        '';
        configureFlags = [
          "--with-vmversion=5.0"
          "--with-src=src/spur64.cog"
          "--without-npsqueak"
          "--enable-fast-bitblt"
          "--disable-dynamicopenssl"
        ];
      };

      "squeak-stack-spur" = buildVM {
        platformDir = "linux64ARMv8";
        vmName = "squeak.stack.spur";
        scriptName = "squeak";
        configureFlagsArray = ''
          (
            CFLAGS="-fpermissive -DNDEBUG -DDEBUGVM=0 -DMUSL -D_GNU_SOURCE -DUSEEVDEV -D__ARM_ARCH_ISA_A64 -DARM64 -D__arm__ -D__arm64__ -D__aarch64__"
          )
        '';
        configureFlags = [
          "--with-vmversion=5.0"
          "--with-src=src/spur64.stack"
          "--disable-cogit"
          "--without-npsqueak"
          "--disable-dynamicopenssl"
        ];
      };
    };

    "x86_64-linux" = {
      "squeak-cog-spur" = buildVM {
        platformDir = "linux64x64";
        vmName = "squeak.cog.spur";
        scriptName = "squeak";
        configureFlagsArray = ''
          (
            CFLAGS="-fpermissive -DNDEBUG -DDEBUGVM=0 -DCOGMTVM=0"
          )
        '';
        configureFlags = [
          "--with-vmversion=5.0"
          "--with-src=src/spur64.cog"
          "--without-npsqueak"
          "--disable-dynamicopenssl"
        ];
      };
    };
  };

  platform = stdenv.targetPlatform.system;
in
vmsByPlatform.${platform} or (throw (
  "Unsupported platform ${platform}: only the following platforms are supported: "
  + builtins.toString (builtins.attrNames vmsByPlatform)
))
