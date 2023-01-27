{ lib, stdenv, python3Packages, fetchFromGitHub, simdjson }:

python3Packages.buildPythonPackage rec {
  pname = "pysimdjson";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "TkTech";
    repo = pname;
    rev = "6b3e58dca8f2c5505e4e90d5083e05c356809022";
    hash = "sha256-m2wTKsPF/05v8TuqrzrjvJXyxl7WBartWrZyTS0WGL4=";
  };

  buildInputs = [
      simdjson
  ];

  doCheck = false;
  
  meta = with lib; {
    description = "pysimdjson";
    homepage = "https://pysimdjson.tkte.ch/";
    maintainers = with maintainers; [ samrose ];
    license = licenses.mit;
    platforms = platforms.linux;
  };

}