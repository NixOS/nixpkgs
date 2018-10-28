{ stdenv, buildPythonPackage, fetchPypi
, pytest, distribute }:

buildPythonPackage rec {
  pname = "almost";
  version = "0.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nqgasnmjnjkg0vbdr8nlw1zgbhihnam5yqv01njgc3qn2gsz4p1";
  };

  buildInputs = [
    distribute
  ];

  # Can't find file in own directory?
  doCheck = false;

  checkInputs = [
    pytest
  ];

  meta = with stdenv.lib; {
    description = "A helper to compare two numbers generously";
    homepage = "https://github.com/sublee/almost";
    license = [
      licenses.bsd
    ];
  };
}
