{ lib, buildPythonPackage, fetchPypi, python, cython }:

buildPythonPackage rec {
  pname = "fastbencode";
  version = "0.0.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-w7F+70R1Wizo/i0GGCc13ADf6JqARtPXMS6/qTmPKEY=";
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
