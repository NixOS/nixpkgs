{ lib, buildPythonPackage, fetchPypi, psutil, docutils }:

buildPythonPackage rec {
  pname = "pynisher";
  version = "0.6.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "111d91aad471375c0509a912415ff90053ef909100facf412511383af107c124";
  };

  propagatedBuildInputs = [ psutil docutils ];

  # no tests in the Pypi archive
  doCheck = false;

  meta = with lib; {
    description = "The pynisher is a little module intended to limit a functions resources.";
    homepage = "https://github.com/sfalkner/pynisher";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };

}

