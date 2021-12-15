{lib, stdenv, fetchFromGitHub, cmake, llvmPackages, setfile}:

stdenv.mkDerivation rec {
  pname = "muparser";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "beltoforion";
    repo = "muparser";
    rev = "v${version}";
    sha256 = "1hprf7h34x9sd9c6jv8p7fbggrhjq3n8dsksmkax2g52addlljcf";
  };

  postPatch = ''
    # Build system expects relative paths in CMAKE_INSTALL_* variables.
    # nixpkgs always passes absolute paths.
    substituteInPlace muparser.pc.in --replace '=''${prefix}/@CMAKE_INSTALL_' '=@CMAKE_INSTALL_'
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs =
    lib.optionals stdenv.isDarwin [setfile]
    # TODO: This may mismatch the LLVM version in the stdenv, see #79818.
    ++ lib.optionals stdenv.cc.isClang [llvmPackages.openmp];

  meta = {
    homepage = "https://beltoforion.de/en/muparser/";
    description = "An extensible high performance math expression parser library written in C++";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
