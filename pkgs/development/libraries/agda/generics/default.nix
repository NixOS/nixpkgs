{
  lib,
  mkDerivation,
  fetchFromGitHub,
  standard-library,
}:

mkDerivation rec {
  pname = "generics";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "flupe";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-B1eT6F0Dp2zto50ulf+K/KYMlMp8Pgc/tO9qkcqn+O8=";
  };

  buildInputs = [
    standard-library
  ];

  # everythingFile = "./README.agda";

  meta = with lib; {
    description = "Library for datatype-generic programming in Agda";
    homepage = src.meta.homepage;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ turion ];
  };
}
