{
  lib,
  buildPythonPackage,
  isPy27,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lazr.uri";
  version = "1.0.6";

  disabled = isPy27; # namespace is broken for python2

  src = fetchPypi {
    inherit pname version;
    sha256 = "5026853fcbf6f91d5a6b11ea7860a641fe27b36d4172c731f4aa16b900cf8464";
  };

  propagatedBuildInputs = [ setuptools ];

  meta = with lib; {
    description = "A self-contained, easily reusable library for parsing, manipulating";
    homepage = "https://launchpad.net/lazr.uri";
    license = licenses.lgpl3;
    maintainers = [ ];
  };
}
