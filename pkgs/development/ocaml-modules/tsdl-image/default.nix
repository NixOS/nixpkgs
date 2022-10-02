{ buildDunePackage
, dune-configurator
, fetchFromGitHub
, lib
, SDL2
, SDL2_image
, tsdl
}:

buildDunePackage rec {
  pname = "tsdl-image";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "sanette";
    repo = pname;
    rev = version;
    sha256 = "sha256-u6VYAwq+2oLn2Kw1+KQRVPswAqeKDSAaPfGLPrzn30s=";
  };

  buildInputs = [
    dune-configurator
  ];

  propagatedBuildInputs = [
    SDL2
    SDL2_image
    tsdl
  ];

  meta = with lib; {
    description = "OCaml SDL2_image bindings to go with Tsdl";
    homepage = "https://github.com/sanette/tsdl-image";
    license = licenses.bsd3;
    maintainers = with maintainers; [ superherointj ];
  };
}
