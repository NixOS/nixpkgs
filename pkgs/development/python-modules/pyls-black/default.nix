{ lib, buildPythonPackage, fetchFromGitHub
, black, toml, pytest, python-language-server, isPy3k
}:

buildPythonPackage rec {
  pname = "pyls-black";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "rupert";
    repo = "pyls-black";
    rev = "v${version}";
    sha256 = "1pagbafb9r9glzy7nbvrq19msjy4wqahrvmc0wll0a0r4msqpi1d";
  };

  disabled = !isPy3k;

  checkPhase = ''
    pytest
  '';

  checkInputs = [ pytest ];

  propagatedBuildInputs = [ black toml python-language-server ];

  meta = with lib; {
    homepage = https://github.com/rupert/pyls-black;
    description = "Black plugin for the Python Language Server";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
