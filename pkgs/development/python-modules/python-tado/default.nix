{ buildPythonPackage
, fetchFromGitHub
, lib
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "python-tado";
  version = "0.17.2";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "wmalgadey";
    repo = "PyTado";
    # https://github.com/wmalgadey/PyTado/issues/62
    rev = "refs/tags/${version}";
    hash = "sha256-w1qtSEpnZCs7+M/0Gywz9AeMxUzz2csHKm9SxBKzmz4=";
  };

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description =
      "Python binding for Tado web API. Pythonize your central heating!";
    homepage = "https://github.com/wmalgadey/PyTado";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
