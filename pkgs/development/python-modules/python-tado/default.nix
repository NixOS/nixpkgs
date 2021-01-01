{ buildPythonPackage, fetchFromGitHub, lib, pytestCheckHook, pythonOlder, requests }:

buildPythonPackage rec {
  pname = "python-tado";
  version = "0.9.0";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "wmalgadey";
    repo = "PyTado";
    rev = version;
    sha256 = "0cr5sxdvjgdrrlhl32rs8pwyay8liyi6prm37y66dn00b41cb5l3";
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
