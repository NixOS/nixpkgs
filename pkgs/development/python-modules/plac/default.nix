{ lib
, buildPythonPackage
, fetchPypi
, python
}:
buildPythonPackage rec {
  pname = "plac";
  version = "1.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "51e332dabc2aed2cd1f038be637d557d116175101535f53eaa7ae854a00f2a74";
  };

  checkPhase = ''
    cd doc
    ${python.interpreter} -m unittest discover -p "*test_plac*"
  '';

  meta = with lib; {
    description = "Parsing the Command Line the Easy Way";
    homepage = "https://github.com/micheles/plac";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ ];
  };
}
