{ stdenv
, lib
, fetchFromGitHub
, arpack
, bison
, blas
, cmake
, flex
, fop
, glpk
, gmp
, lapack
, libxml2
, libxslt
, llvmPackages
, pkg-config
, plfit
, python3
, sourceHighlight
, xmlto
}:

assert (blas.isILP64 == lapack.isILP64 &&
        blas.isILP64 == arpack.isILP64 &&
        !blas.isILP64);

stdenv.mkDerivation (finalAttrs: {
  pname = "igraph";
  version = "0.10.7";

  src = fetchFromGitHub {
    owner = "igraph";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    hash = "sha256-1ge5V9G2jmIWQE5TW7+6cXCV9viFkhcnjpYrLQVLrgg=";
  };

  postPatch = ''
    echo "${finalAttrs.version}" > IGRAPH_VERSION
  '';

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [
    bison
    cmake
    flex
    fop
    libxml2
    libxslt
    pkg-config
    python3
    sourceHighlight
    xmlto
  ];

  buildInputs = [
    arpack
    blas
    glpk
    gmp
    lapack
    libxml2
    plfit
  ] ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  cmakeFlags = [
    "-DIGRAPH_USE_INTERNAL_BLAS=OFF"
    "-DIGRAPH_USE_INTERNAL_LAPACK=OFF"
    "-DIGRAPH_USE_INTERNAL_ARPACK=OFF"
    "-DIGRAPH_USE_INTERNAL_GLPK=OFF"
    "-DIGRAPH_USE_INTERNAL_GMP=OFF"
    "-DIGRAPH_USE_INTERNAL_PLFIT=OFF"
    "-DIGRAPH_GLPK_SUPPORT=ON"
    "-DIGRAPH_GRAPHML_SUPPORT=ON"
    "-DIGRAPH_OPENMP_SUPPORT=ON"
    "-DIGRAPH_ENABLE_LTO=AUTO"
    "-DIGRAPH_ENABLE_TLS=ON"
    "-DBUILD_SHARED_LIBS=ON"
  ];

  doCheck = true;

  postInstall = ''
    mkdir -p "$out/share"
    cp -r doc "$out/share"
  '';

  postFixup = lib.optionalString stdenv.isDarwin ''
    install_name_tool -change libblas.dylib ${blas}/lib/libblas.dylib $out/lib/libigraph.dylib
  '';

  passthru.tests = {
    python = python3.pkgs.igraph;
  };

  meta = with lib; {
    description = "C library for complex network analysis and graph theory";
    homepage = "https://igraph.org/";
    changelog = "https://github.com/igraph/igraph/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ MostAwesomeDude dotlambda ];
  };
})
