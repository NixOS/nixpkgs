{ lib, buildPythonPackage, fetchFromGitHub
, black, toml, pytest, python-language-server, isPy3k
}:

buildPythonPackage rec {
  pname = "pyls-black";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "rupert";
    repo = "pyls-black";
    rev = "v${version}";
    sha256 = "0xa3iv8nhnj0lw0dh41qb0dqp55sb6rdxalbk60v8jll6qyc0si8";
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
