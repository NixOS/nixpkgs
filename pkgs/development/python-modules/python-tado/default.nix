{ buildPythonPackage, fetchFromGitHub, lib, pytestCheckHook, pythonOlder, requests }:

buildPythonPackage rec {
  pname = "python-tado";
  version = "0.12.0";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "wmalgadey";
    repo = "PyTado";
    rev = version;
    hash = "sha256-n+H6H2ORLizv9cn1P5Cd8wHDWMNonPrs+x+XMQbEzZQ=";
  };

  propagatedBuildInputs = [ requests ];
  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description =
      "Python binding for Tado web API. Pythonize your central heating!";
    homepage = "https://github.com/wmalgadey/PyTado";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
