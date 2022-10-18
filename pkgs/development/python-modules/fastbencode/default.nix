{ lib, buildPythonPackage, fetchPypi, python, cython }:

buildPythonPackage rec {
  pname = "fastbencode";
  version = "0.0.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jwAXWJwrybcV6CrDBlsKY/KL3xdTw016pJUZnAXmxsk=";
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
