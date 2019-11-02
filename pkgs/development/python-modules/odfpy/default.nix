{ lib
, buildPythonPackage
, fetchPypi
, defusedxml
, pytest
}:

buildPythonPackage rec {
  pname = "odfpy";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "596021f0519623ca8717331951c95e3b8d7b21e86edc7efe8cb650a0d0f59a2b";
  };

  propagatedBuildInputs = [ defusedxml ];

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

  meta = {
    description = "Python API and tools to manipulate OpenDocument files";
    homepage = https://github.com/eea/odfpy;
    license = lib.licenses.asl20;
  };
}
