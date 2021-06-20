{ stdenv, lib, fetchFromGitHub
, makeWrapper

, withDocs ? false
, dosbox
, ghostscript
, withGUI ? false
}:

let
  bindirs = if (stdenv.hostPlatform.isWindows && stdenv.hostPlatform.is64bit) then [
    "binnt64" "binnt"
  ] else if stdenv.hostPlatform.isWindows then [
    "binnt" "binw"
  ] else if stdenv.hostPlatform.isDarwin then [
    "osx64"
  ] else if stdenv.hostPlatform.is64bit then [
    "binl64" "binl"
  ] else [
    "binl"
  ];
in
stdenv.mkDerivation rec {
  pname = "open-watcom-v2";
  version = "unstable-2021-06-16";

  src = fetchFromGitHub {
    owner = "open-watcom";
    repo = "open-watcom-v2";
    rev = "aa8d53943c877f1290294e5b85f53836c461802d";
    sha256 = "12digi6jnd91x7qczmcmwwsrqxjkjis8ww3saki8zc8kplqcbfy4";
  };

  postPatch = ''
    patchShebangs *.sh
    substituteInPlace bld/watcom/h/banner.h \
      --replace '__TIME__' "\"$(date -ud "@$SOURCE_DATE_EPOCH")\"" \
      --replace '_MACROSTR( _CYEAR )' "\"$(date -ud "@$SOURCE_DATE_EPOCH" '+%Y')\""
  '' + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    substituteInPlace build/mif/local.mif \
      --replace '-static' '-L ${stdenv.cc.libc.static}/lib -static'
  '';

  nativeBuildInputs = [ makeWrapper ]
    ++ lib.optional (withDocs || withGUI) dosbox
    ++ lib.optional withDocs ghostscript;

  configurePhase = ''
    runHook preConfigure

    export OWROOT=$(realpath $PWD)
    export OWTOOLS=${if stdenv.cc.isClang then "CLANG" else "GCC"}
    export OWDOCBUILD=${if withDocs then "1" else "0"}
    ${lib.optionalString withDocs "export OWGHOSTSCRIPTPATH=${ghostscript}/bin"}
    export OWGUINOBUILD=${if withGUI then "0" else "1"}
    export OWNOBUILD=
    export OWDISTRBUILD=0
    ${lib.optionalString (withDocs || withGUI) "export OWDOSBOX=dosbox"}
    export OWOBJDIR=binbuild
    export OWVERBOSE=1
    export OWRELROOT=$out/lib/openwatcom

    source cmnvars.sh

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    ./build.sh rel

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out/bin

    for exe in $(find $out/lib/openwatcom/${builtins.head bindirs}/ -type f -executable ${lib.optionalString stdenv.hostPlatform.isLinux "-not -iname '*.so' -not -iname '*.exe'"}); do
      makeWrapper $exe $out/bin/$(basename $exe) \
        --set-default WATCOM $out/lib/openwatcom \
        --prefix PATH : ${lib.strings.concatMapStringsSep ":" (dir: "${placeholder "out"}/lib/openwatcom/${dir}") bindirs} \
        --set-default EDPATH $out/lib/openwatcom/eddat \
        --set-default INCLUDE $out/lib/openwatcom/${lib.optionalString (!stdenv.hostPlatform.isWindows) "l"}h
    done

    runHook postInstall
  '';

  # Breaks many tools
  dontStrip = true;

  meta = with lib; {
    description = "The v2 fork of the Open Watcom suite of compilers and tools";
    longDescription = ''
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
    '';
    homepage = "https://open-watcom.github.io";
    license = licenses.watcom;
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "x86_64-windows" "i686-windows" ];
    maintainers = with maintainers; [ OPNA2608 ];
  };
}
