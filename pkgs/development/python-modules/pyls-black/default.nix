{ lib, buildPythonPackage, fetchFromGitHub
, black, toml, pytest, python-language-server, isPy3k
}:

buildPythonPackage rec {
  pname = "pyls-black";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "rupert";
    repo = "pyls-black";
    rev = "v${version}";
    sha256 = "1ynynay9g6yma39szbzf15ypq3c72fg1i0kjmq1dwxarj68i2gf9";
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
