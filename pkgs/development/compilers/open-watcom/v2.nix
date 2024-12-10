{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  dosbox,

  # Docs cause an immense increase in build time, up to 2 additional hours
  withDocs ? false,
  ghostscript,
  withGUI ? false,
}:

stdenv.mkDerivation rec {
  pname = "${passthru.prettyName}-unwrapped";
  # nixpkgs-update: no auto update
  version = "0-unstable-2024-05-14";

  src = fetchFromGitHub {
    owner = "open-watcom";
    repo = "open-watcom-v2";
    rev = "d3733a7fca1d02ad91b58b377ecb38e1293889db";
    hash = "sha256-gDrmm7hd07lv0KhkP7Bys5qCuCCH+t/XvlftCYlCyI8=";
  };

  postPatch =
    ''
      patchShebangs *.sh

      for dateSource in bld/wipfc/configure; do
        substituteInPlace $dateSource \
          --replace '`date ' '`date -ud "@$SOURCE_DATE_EPOCH" '
      done

      substituteInPlace bld/watcom/h/banner.h \
        --replace '__DATE__' "\"$(date -ud "@$SOURCE_DATE_EPOCH" +'%b %d %Y')\"" \
        --replace '__TIME__' "\"$(date -ud "@$SOURCE_DATE_EPOCH" +'%T')\""

      substituteInPlace build/makeinit \
        --replace '$+$(%__CYEAR__)$-' "$(date -ud "@$SOURCE_DATE_EPOCH" +'%Y')"
    ''
    + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      substituteInPlace build/mif/local.mif \
        --replace '-static' ""
    '';

  nativeBuildInputs =
    [
      dosbox
    ]
    ++ lib.optionals withDocs [
      ghostscript
    ];

  configurePhase = ''
    runHook preConfigure

    export OWROOT=$(realpath $PWD)
    export OWTOOLS=${if stdenv.cc.isClang then "CLANG" else "GCC"}
    export OWDOCBUILD=${if withDocs then "1" else "0"}
    export OWGHOSTSCRIPTPATH=${lib.optionalString withDocs "${ghostscript}/bin"}
    export OWGUINOBUILD=${if withGUI then "0" else "1"}
    export OWNOBUILD=
    export OWDISTRBUILD=0
    export OWDOSBOX=${dosbox}/bin/dosbox
    export OWVERBOSE=0
    export OWRELROOT=$out

    source cmnvars.sh

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    ./build.sh build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ./build.sh cprel

    runHook postInstall
  '';

  # Stripping breaks many tools
  dontStrip = true;

  passthru = {
    prettyName = "open-watcom-v2";
    updateScript = unstableGitUpdater {
      url = "https://github.com/open-watcom/open-watcom-v2.git";
      # no numerical releases, monthly "YYYY-MM-DD-Build" tags and daily "Current-build", "Last-CI-build" & "Coverity-scan" retagging
      hardcodeZeroVersion = true;
    };
  };

  meta = with lib; {
    description = "The v2 fork of the Open Watcom suite of compilers and tools";
    longDescription =
      ''
        A fork of Open Watcom: A C/C++/Fortran compiler and assembler suite
        targeting a multitude of architectures (x86, IA-32, Alpha AXP, MIPS,
        PowerPC) and operating systems (DOS, OS/2, Windows, Linux).

        Main differences from Open Watcom 1.9:

        - New two-phase build system - Open Watcom can be built by the host's
          native C/C++ compiler or by itself
        - Code generator properly initializes pointers by DLL symbol addresses
        - DOS tools now support long file names (LFN) if appropriate LFN driver
          is loaded by DOS
        - Open Watcom is ported to 64-bit hosts (Win64, Linux x64)
        - Librarian supports x64 CPU object modules and libraries
        - RDOS 32-bit C run-time compact memory model libraries are fixed
        - Resource compiler and Resource editors support Win64 executables
        - Open Watcom text editor is now self-contained, it can be used as
          standalone tool without any requirements for any additional files or
          configuration
        - Broken C++ compiler pre-compiled header template support is fixed
        - Many C++ compiler crashes are fixed
        - Debugger has no length limit for any used environment variable
      ''
      + lib.optionalString (!withDocs) ''

        The documentation has been excluded from this build for build time reasons. It can be found here:
        https://github.com/open-watcom/open-watcom-v2/wiki/Open-Watcom-Documentation
      '';
    homepage = "https://open-watcom.github.io";
    license = licenses.watcom;
    platforms = with platforms; windows ++ unix;
    badPlatforms = platforms.riscv ++ [
      "powerpc64-linux"
      "powerpc64le-linux"
      "mips64el-linux"
    ];
    maintainers = with maintainers; [ OPNA2608 ];
  };
}
