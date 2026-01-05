{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  sortedcontainers,
}:

buildPythonPackage rec {
  version = "3.1.0";
  pname = "intervaltree";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "902b1b88936918f9b2a19e0e5eb7ccb430ae45cde4f39ea4b36932920d33952d";
  };

  build-system = [ setuptools ];

  dependencies = [ sortedcontainers ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    rm -rf build
  '';

  meta = {
    description = "Editable interval tree data structure for Python 2 and 3";
    homepage = "https://github.com/chaimleib/intervaltree";
    license = [ lib.licenses.asl20 ];
    maintainers = [ lib.maintainers.bennofs ];
  };
}
