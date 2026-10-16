{
  autoPatchelfHook,
  buildFHSEnv,
  lib,
  makeWrapper,
  requireFile,
  stdenv,
  writeScript,

  bash,
  coreutils,
  fontconfig,
  freetype,
  glib,
  glibc,
  gperftools,
  gtk2,
  hostname-debian,
  liberation_ttf,
  libpng,
  libx11,
  libxcb,
  libxcrypt,
  libxext,
  libxi,
  libxrender,
  libxtst,
  ncurses,
  ncurses5,
  patchelf,
  pixman,
  procps,
  util-linuxMinimal,
  zlib,

  # Select which devices support do you want to install. This string follows install_config.txt format.
  devices ? "Virtex UltraScale+ HBM:1,DocNav:1,Kintex UltraScale:1,Artix UltraScale+:1,Spartan-7:1,Artix-7:1,Virtex UltraScale+:1,Zynq UltraScale+ MPSoC:1,Zynq-7000:1,Virtex UltraScale+ 58G:1,Kintex-7:1,Install Devices for Kria SOMs and Starter Kits:1,Kintex UltraScale+:1",
}:
let
  pname = "vivado";
  version = "2025.2";
  meta = {
    description = "Suite for synthesis and analysis of hardware description language (HDL) designs";
    homepage = "https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ awariac ];
    platforms = [ "x86_64-linux" ];
  };

  archiveName = "FPGAs_AdaptiveSoCs_Unified_SDI_2025.2_1114_2157_1.tar";
  builtinJavaBin = "tps/lnx64/jre21.0.5_11/bin/java";

  extractedSource = stdenv.mkDerivation rec {
    pname = "vivado-installer-extracted";
    inherit version;

    src = requireFile rec {
      name = archiveName;
      url = "https://account.amd.com/en/forms/downloads/xef.html?filename=${archiveName}";
      sha256 = "sha256-zRAhsEFm5DwNWcu97XsWh92l6drYkLgkkvhysv4ypyU=";
      message = ''
        Unfortunately, we cannot download file ${name} automatically.
        Please go to ${url} to download it yourself, and add it to the Nix store with "nix-store --add-fixed"
      '';
    };

    buildInputs = [ patchelf ];

    inherit builtinJavaBin;
    builder = writeScript "builder" ''
      #! ${bash}/bin/bash
      source $stdenv/setup

      mkdir -p $out/
      tar -xvf $src --strip-components=1 -C $out/ --wildcards "FPGAs_AdaptiveSoCs_Unified*"

      patchShebangs $out/
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        $out/${builtinJavaBin}
      sed -i -- 's|/bin/rm|rm|g' $out/xsetup
    '';
  };

  vivadoPackage = stdenv.mkDerivation {
    inherit meta pname version;

    nativeBuildInputs = [
      zlib
      autoPatchelfHook
    ];
    buildInputs = [
      coreutils
      hostname-debian
      makeWrapper
      patchelf
      procps
    ];

    dontAutoPatchelf = true;
    autoPatchelfIgnoreMissingDeps = [ "*" ];

    extracted = "${extractedSource}";

    inherit devices;
    inherit builtinJavaBin;
    builder = ./builder.sh;

    libPath = lib.makeLibraryPath [
      fontconfig
      freetype
      glib
      glibc.dev
      gperftools
      gtk2
      liberation_ttf
      libpng
      libx11
      libxcb
      libxcrypt
      libxext
      libxi
      libxrender
      libxtst
      ncurses
      ncurses5
      pixman
      stdenv.cc.cc
      util-linuxMinimal
      zlib
    ];
  };
in
buildFHSEnv {
  inherit meta pname version;

  targetPkgs = _pkgs: [ vivadoPackage ];

  runScript = "vivado";
}
