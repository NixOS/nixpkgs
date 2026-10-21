{
  lib,
  stdenv,
  fetchFromGitHub,
  xercesc,
  getopt,
  cmake,
}:

stdenv.mkDerivation {
  pname = "xalan-c";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "xalan-c";
    rev = "Xalan-C_1_12_0";
    sha256 = "sha256:0q1204qk97i9h14vxxq7phcfpyiin0i1zzk74ixvg4wqy87b62s8";
  };

  patches = [
    # See https://github.com/llvm/llvm-project/issues/96859
    # xalan-c contains a templated code path that tries to access non-existent methods,
    # but before Clang 19 and GCC 15 this was no error as the template was never instantiated.
    # Note that the suggested fix of adding "-fdelayed-template-parsing"
    # to CXX_FLAGS would be sufficient for Clang 19, but as it would break again
    # once we upgrade to GCC 15, we remove the dead code entirely.
    ./0001-clang19-gcc15-compat.patch
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail 'cmake_minimum_required(VERSION 3.2.0)' 'cmake_minimum_required(VERSION 3.10.0)'
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    xercesc
    getopt
  ];

  meta = {
    homepage = "https://xalan.apache.org/";
    description = "XSLT processor for transforming XML documents";
    mainProgram = "Xalan";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
