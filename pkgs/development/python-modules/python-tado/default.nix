{ buildPythonPackage, fetchFromGitHub, lib, pytestCheckHook, pythonOlder, requests }:

buildPythonPackage rec {
  pname = "python-tado";
  version = "0.11.0";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "wmalgadey";
    repo = "PyTado";
    rev = version;
    sha256 = "0fw4f9gqnhxwpxyb34qi8bl5pmzz13h4x3mdk903hhjyccanqncr";
  };

  propagatedBuildInputs = [ requests ];
  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description =
      "Python binding for Tado web API. Pythonize your central heating!";
    homepage = "https://github.com/wmalgadey/PyTado";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
