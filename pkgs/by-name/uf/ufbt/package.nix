{
  lib,
  python3Packages,
  fetchPypi,
  fetchzip,
  scons,
  python3,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  ncurses5,
  libxcrypt-legacy,
  openocd,
  dfu-util,
  llvmPackages,
  heatshrink,
  protobuf,
}:
let
  flipper-sdk = fetchzip {
    url = "https://update.flipperzero.one/builds/firmware/1.4.3/flipper-z-f7-sdk-1.4.3.zip";
    hash = "sha256-lU9/dPYg7J/2/KOgOxrf6THypktF0aYUefpaV47/XTk=";
    stripRoot = false;
  };
  gcc-arm-13-2 = stdenv.mkDerivation {
    pname = "gcc-arm-embedded-13.2";
    version = "13.2.Rel1";
    src = fetchurl {
      url = "https://developer.arm.com/-/media/Files/downloads/gnu/13.2.rel1/binrel/arm-gnu-toolchain-13.2.rel1-x86_64-arm-none-eabi.tar.xz";
      sha256 = "6cd1bbc1d9ae57312bcd169ae283153a9572bd6a8e4eeae2fedfbc33b115fdbb";
    };
    installPhase = ''
      mkdir -p $out
      cp -r * $out/
    '';
    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [
      stdenv.cc.cc.lib
      ncurses5
      python3
      libxcrypt-legacy
    ];
  };
  ufbt-python = python3.withPackages (
    ps: with ps; [
      pyserial
      oslex
      ansi
      protobuf
      pyelftools
      setuptools
      colorlog
    ]
  );
in
python3Packages.buildPythonApplication rec {
  pname = "ufbt";
  version = "0.2.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TxqFiFhZjtLiW7q2ni6mBLwAdYw7Ho7PiXophmFXNjs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "setuptools-git-versioning<2" "setuptools-git-versioning"
    mkdir -p $out/bin
    ln -s ${gcc-arm-13-2}/bin/arm-none-eabi-gdb $out/bin/arm-none-eabi-gdb-py3
  '';

  build-system = with python3Packages; [
    setuptools
    setuptools-git-versioning
  ];

  dependencies = with python3Packages; [
    pyserial
    oslex
    ansi
    protobuf
    pyelftools
    colorlog
  ];
  makeWrapperArgs = [
    "--set FBT_NOENV 1"
    "--set UFBT_SDK_PATH ${flipper-sdk}"
    "--set UFBT_OPENOCD ${lib.getBin openocd}/bin/openocd"
    "--set UFBT_DFUUTIL ${lib.getBin dfu-util}/bin/dfu-util"
    "--set UFBT_CLANGD ${lib.getBin llvmPackages.clang-unwrapped}/bin/clangd"
    "--set UFBT_PROTOC ${lib.getBin protobuf}/bin/protoc"
    "--set UFBT_HEATSHRINK ${lib.getBin heatshrink}/bin/heatshrink"
    "--set UFBT_TOOLCHAIN_BINDIR ${gcc-arm-13-2}/bin"
    "--prefix PYTHONPATH : ${scons}/lib/python${python3.pythonVersion}/site-packages"
    "--prefix PATH : ${
      lib.makeBinPath [
        ufbt-python
        gcc-arm-13-2
        dfu-util
        openocd
        llvmPackages.clang-unwrapped
        heatshrink
      ]
    }"
    "--set UFBT_HOME .ufbt_state"
  ];
  meta = {
    description = "Micro Flipper Build Tool";
    homepage = "https://github.com/flipperdevices/flipperzero-ufbt";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ pignated ];
    platforms = [
      "x86_64-linux"
    ];
    mainProgram = "ufbt";
  };
}
