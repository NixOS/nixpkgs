{ lib, fetchpatch, buildPythonPackage, fetchPypi, python, nose, parameterized }:

buildPythonPackage rec {
  pname = "pprintpp";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00v4pkyiqc0y9qjnp3br58a4k5zwqdrjjxbcsv39vx67w84630pa";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/wolever/pprintpp/commit/873217674cc824b4c1cfdad4867c560c60e8d806.patch";
      sha256 = "0rqxzxawr83215s84mfzh1gnjwjm2xv399ywwcl4q7h395av5vb3";
    })
  ];

  checkInputs = [ nose parameterized ];
  checkPhase = ''
    ${python.interpreter} test.py
  '';

  meta = with lib; {
    homepage = https://github.com/wolever/pprintpp;
    description = "A drop-in replacement for pprint that's actually pretty";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
