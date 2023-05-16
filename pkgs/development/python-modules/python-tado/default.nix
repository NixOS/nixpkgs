<<<<<<< HEAD
{ buildPythonPackage
, fetchFromGitHub
, lib
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage {
  pname = "python-tado";
  version = "0.16.0";
  format = "setuptools";
=======
{ buildPythonPackage, fetchFromGitHub, lib, pytestCheckHook, pythonOlder, requests }:

buildPythonPackage rec {
  pname = "python-tado";
  version = "0.12.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "wmalgadey";
    repo = "PyTado";
<<<<<<< HEAD
    # https://github.com/wmalgadey/PyTado/issues/62
    rev = "674dbc450170a380e76460c22d6ba943dfedb8e9";
    hash = "sha256-gduqQVw/a64aDzTHFmgZu7OVB53jZb7L5vofzL3Ho6s=";
  };

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];
=======
    rev = version;
    hash = "sha256-n+H6H2ORLizv9cn1P5Cd8wHDWMNonPrs+x+XMQbEzZQ=";
  };

  propagatedBuildInputs = [ requests ];
  nativeCheckInputs = [ pytestCheckHook ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description =
      "Python binding for Tado web API. Pythonize your central heating!";
    homepage = "https://github.com/wmalgadey/PyTado";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
