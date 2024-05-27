{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest7CheckHook,
  pythonOlder,
  six,
}:

buildPythonPackage rec {
  pname = "nocaselist";
  version = "2.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MnCLcAoaUxM+a7XMUzMsl3Wwx8lZpflyV5MXH9L0yKU=";
  };

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytest7CheckHook ];

  pythonImportsCheck = [ "nocaselist" ];

  meta = with lib; {
    description = "A case-insensitive list for Python";
    homepage = "https://github.com/pywbem/nocaselist";
    changelog = "https://github.com/pywbem/nocaselist/blob/${version}/docs/changes.rst";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ freezeboy ];
  };
}
