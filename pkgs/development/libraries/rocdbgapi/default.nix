{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, rocm-cmake
, git
, rocm-comgr
, rocm-runtime
, texlive
, doxygen
, graphviz
, buildDocs ? true
}:

let
  latex = lib.optionalAttrs buildDocs texlive.combine {
    inherit (texlive) scheme-small
    latexmk
    varwidth
    multirow
    hanging
    adjustbox
    collectbox
    stackengine
    enumitem
    alphalph
    wasysym
    sectsty
    tocloft
    newunicodechar
    etoc
    helvetic
    wasy
    courier;
  };
in stdenv.mkDerivation (finalAttrs: {
  pname = "rocdbgapi";
  version = "5.4.1";

  outputs = [
    "out"
  ] ++ lib.optionals buildDocs [
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "ROCm-Developer-Tools";
    repo = "ROCdbgapi";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-KoFa6JzoEPT5/ns9X/hMfu8bOh29HD9n2qGJ3gzhiBA=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    git
  ] ++ lib.optionals buildDocs [
    latex
    doxygen
    graphviz
  ];

  buildInputs = [
    rocm-comgr
    rocm-runtime
  ];

  # Unfortunately, it seems like we have to call make on this manually
  postBuild = lib.optionalString buildDocs ''
    export HOME=$(mktemp -d)
    make -j$NIX_BUILD_CORES doc
  '';

  postInstall = ''
    substituteInPlace $out/lib/cmake/amd-dbgapi/amd-dbgapi-config.cmake \
      --replace "/build/source/build/" ""

    substituteInPlace $out/lib/cmake/amd-dbgapi/amd-dbgapi-targets.cmake \
      --replace "/build/source/build" "$out"
  '' + lib.optionalString buildDocs ''
    mv $out/share/html/amd-dbgapi $doc/share/doc/amd-dbgapi/html
    rmdir $out/share/html
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "Debugger support for control of execution and inspection state";
    homepage = "https://github.com/ROCm-Developer-Tools/ROCdbgapi";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version;
  };
})
