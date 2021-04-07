{ lib, buildPythonPackage, fetchFromGitHub
, black, toml, pytest, python-language-server, isPy3k
}:

buildPythonPackage rec {
  pname = "pyls-black";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "rupert";
    repo = "pyls-black";
    rev = "v${version}";
    sha256 = "0cjf0mjn156qp0x6md6mncs31hdpzfim769c2lixaczhyzwywqnj";
  };

  disabled = !isPy3k;

  checkPhase = ''
    pytest
  '';

  checkInputs = [ pytest ];

  propagatedBuildInputs = [ black toml python-language-server ];

  meta = with lib; {
    homepage = "https://github.com/rupert/pyls-black";
    description = "Black plugin for the Python Language Server";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
