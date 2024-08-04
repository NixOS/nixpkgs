{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  requests,
  pyyaml,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "openapi3";
  version = "1.8.2";
  pyproject = true;

  disabled = pythonOlder "3.8";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ohpJBXPYnKaa2ny+WFrbL8pJZCV/bzod9THxKBVFXSw=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    requests
    pyyaml
  ];

  nativeCheckinputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "openapi3" ];

  meta = with lib; {
    changelog = "https://github.com/Dorthu/openapi3/releases/tag/${version}";
    description = "Python3 OpenAPI 3 Spec Parser";
    homepage = "https://github.com/Dorthu/openapi3";
    license = licenses.bsd3;
    maintainers = with maintainers; [ techknowlogick ];
  };
}
