{
  lib,
  fetchPypi,
  buildPythonPackage,
  pythonOlder,
  setuptools,
  # dependencies
  astunparse,
  gast,
  termcolor,
}:

buildPythonPackage rec {
  pname = "diastatic-malt";
  version = "2.15.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  # Use fetchPypi to avoid the updater script to migrate it to `reactivex` which
  # is being developed in the same repository
  src = fetchPypi {
    inherit version;
    pname = "diastatic-malt";
    sha256 = "7eb90d8c30b7ff16b4e84c3a65de2ff7f5b7b9d0f5cdea23918e747ff7fb5320";
  };

  build-system = [ setuptools ];

  dependencies = [
    astunparse
    gast
    termcolor
  ];

  pythonImportsCheck = [ "malt" ];

  meta = {
    homepage = "https://github.com/PennyLaneAI/diastatic-malt";
    description = "Source-to-source transformations and operator overloading in Python";
    maintainers = with lib.maintainers; [ anderscs ];
    license = lib.licenses.asl20;
  };
}
