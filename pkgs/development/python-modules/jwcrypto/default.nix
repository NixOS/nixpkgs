{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, deprecated
, pytestCheckHook
, pythonOlder
, setuptools
, typing-extensions
}:

buildPythonPackage rec {
  pname = "jwcrypto";
  version = "1.5.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CBX7q2E9uZuthWkdpfE2+IYEIzlmZ3KKJkvPpuHbNrA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    cryptography
    deprecated
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "jwcrypto"
  ];

  meta = with lib; {
    description = "Implementation of JOSE Web standards";
    homepage = "https://github.com/latchset/jwcrypto";
    changelog = "https://github.com/latchset/jwcrypto/releases/tag/v${version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
