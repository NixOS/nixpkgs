{ lib, buildPythonPackage, fetchPypi, python, cython }:

buildPythonPackage rec {
  pname = "fastbencode";
  version = "0.0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-pQhjLGRfLj/7tJhMtUQDXIlG1v7Iz+CuxeVWNAdzzpw=";
  };

  nativeBuildInputs = [ cython ];

  pythonImportsCheck = [ "fastbencode" ];

  checkPhase = ''
    ${python.interpreter} -m unittest fastbencode.tests.test_suite
  '';

  meta = with lib; {
    description = "Fast implementation of bencode";
    homepage = "https://github.com/breezy-team/fastbencode";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.marsam ];
  };
}
