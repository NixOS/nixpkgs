{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  dune-configurator,
}:

buildDunePackage rec {
  pname = "parmap";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "rdicosmo";
    repo = pname;
    rev = version;
    hash = "sha256-tBu7TGtDOe5FbxLZuz6nl+65aN9FHIngq/O4dJWzr3Q=";
  };

  minimalOCamlVersion = "4.03";

  buildInputs = [
    dune-configurator
  ];

  doCheck = false; # prevent running slow benchmarks

  meta = with lib; {
    description = "Library for multicore parallel programming";
    downloadPage = "https://github.com/rdicosmo/parmap";
    homepage = "https://rdicosmo.github.io/parmap";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
