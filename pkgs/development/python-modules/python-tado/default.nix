{ buildPythonPackage
, fetchFromGitHub
, lib
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "python-tado";
  version = "0.17.4";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "wmalgadey";
    repo = "PyTado";
    rev = "refs/tags/${version}";
    hash = "sha256-Wdd9HdsQjaYlL8knhMuO87+dom+aTsmrLRK0UdrpsbQ=";
  };

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Python binding for Tado web API. Pythonize your central heating!";
    homepage = "https://github.com/wmalgadey/PyTado";
    changelog = "https://github.com/wmalgadey/PyTado/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
