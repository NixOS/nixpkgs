{
  lib,
  buildPythonPackage,
  fetchPypi,
  flake8,
  six,
  pythonOlder,
  importlib-metadata,
}:

buildPythonPackage rec {
  pname = "orderedmultidict";
  version = "1.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bc2v0yflsxjyyjx4q9wqx0j3bvzcw9z87d5pz4iqac7bsxhn1q4";
  };

  nativeCheckInputs = [ flake8 ];

  propagatedBuildInputs = [ six ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  meta = {
    description = "Ordered Multivalue Dictionary";
    homepage = "https://github.com/gruns/orderedmultidict";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ vanzef ];
  };
}
