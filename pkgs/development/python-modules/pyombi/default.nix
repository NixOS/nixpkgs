{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyombi";
  version = "0.1.10";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-/bKYgjh2gebDBBExymjD2iVVx3lHojJw8rSALVira/o=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyombi" ];

  meta = {
    description = "Python module to retrieve information from Ombi";
    homepage = "https://github.com/larssont/pyombi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
