{
  lib,
  stdenv,
  fetchFromGitHub,
  libffi,
  qt5,
  lld,
  parallel,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unilang";
  version = "0.13";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "unilang";
    rev = "V" + finalAttrs.version;
    hash = "sha256-GWY9FtbX3+FrxRSKWPcJKXm43tWF6AHggjaLr3YtN/8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    lld
    parallel
    pkg-config
    qt5.qtbase
    qt5.qtdeclarative
    qt5.wrapQtAppsHook
  ];

  patchPhase = ''
    runHook prePatch

    # `std.txt` is a component of Unilang installation, and must be kept in the output.
    substituteInPlace ./src/Main.cpp \
        --replace-fail \"std.txt\" \"$out/lib/std.txt\"

    # Trim the shabang.
    sed --in-place --expression='1{/^#!/d}' ./build.sh

    runHook postPatch
  '';

  postPatch = ''
    # Trim the shabang.
    sed --in-place --expression='1{/^#!/d}' ./test.sh

    # Change the paths of test logs.
    mkdir -p ./test
    substituteInPlace ./test.sh \
        --replace-fail =/tmp/out =$(pwd)/test/out.log \
        --replace-fail =/tmp/err =$(pwd)/test/err.log
  '';

  buildPhase = ''
    runHook preBuild

    export Unilang_Output=$out/bin/unilang
    export Unilang_BuildDir=$(pwd)/build/
    export UNILANG_NO_LLVM=0; # LLVM-based JIT is disabled for lack of LLVM 7.
    export LDFLAGS=-fuse-ld=lld
    ./build.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp ./std.txt $out/lib/

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    export UNILANG=$out/bin/unilang
    ./test.sh

    runHook postInstallCheck
  '';

  qtWrapperArgs =
    let
      runtimeLibPath = lib.strings.makeLibraryPath [
        libffi
        qt5.qtbase
        qt5.qtdeclarative
        stdenv.cc.cc.lib
      ];
    in
    [ "--suffix LD_LIBRARY_PATH : ${runtimeLibPath}" ];

  meta = {
    description = "General purpose programming language";
    longDescription = ''
      Unilang is a general purpose programming language project proposed to
      adapt to more effective and flexible development of desktop environment
      applications.
    '';
    homepage = "https://github.com/linuxdeepin/unilang/";
    changelog =
      # Currently zh-CN only.
      "https://github.com/linuxdeepin/unilang/raw/V${finalAttrs.version}/ReleaseNotes.zh-CN.md";
    license = lib.licenses.bsd2Patent;
    maintainers = with lib.maintainers; [ rc-zb ];
    mainProgram = "unilang";
    platforms = lib.platforms.linux;
  };
})
