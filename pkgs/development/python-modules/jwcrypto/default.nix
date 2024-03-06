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
  version = "1.5.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WefV5FidGwcXDzaOIMMusyoCORGAapcjsfQ6DYswKNY=";
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
