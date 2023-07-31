{ lib, mkDerivation, fetchFromGitHub, standard-library }:

mkDerivation rec {
  pname = "generics";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "flupe";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6s4r9J1AfRP6C5dSoTzrbiaIPLIaw8n2xmL3GD/XiLI=";
  };

  buildInputs = [
    standard-library
  ];

  # everythingFile = "./README.agda";

  meta = with lib; {
    description =
      "Library for datatype-generic programming in Agda";
    homepage = src.meta.homepage;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ turion ];
  };
}
