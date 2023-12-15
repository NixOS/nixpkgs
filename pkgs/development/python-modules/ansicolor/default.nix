{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ansicolor";
  version = "0.3.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3b840a6b1184b5f1568635b1adab28147947522707d41ceba02d5ed0a0877279";
  };

  meta = with lib; {
    homepage = "https://github.com/numerodix/ansicolor/";
    description = "A library to produce ansi color output and colored highlighting and diffing";
    license = licenses.asl20;
    maintainers = with maintainers; [ andsild ];
  };
}
