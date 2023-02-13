{ lib
, buildPythonPackage
, fetchFromGitHub
, black
, toml
, pytestCheckHook
, python-language-server
, isPy3k
}:

buildPythonPackage rec {
  pname = "pyls-black";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "rupert";
    repo = "pyls-black";
    rev = "v${version}";
    sha256 = "0bkhfnlik89j3yamr20br4wm8975f20v33wabi2nyxvj10whr5dj";
  };

  disabled = !isPy3k;

  nativeCheckInputs = [ pytestCheckHook ];

  propagatedBuildInputs = [ black toml python-language-server ];

  meta = with lib; {
    homepage = "https://github.com/rupert/pyls-black";
    description = "Black plugin for the Python Language Server";
    license = licenses.mit;
    maintainers = [ ];
  };
}
