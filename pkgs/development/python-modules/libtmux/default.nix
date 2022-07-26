{ lib
, fetchFromGitHub
, buildPythonPackage
, poetry-core
, pytestCheckHook
, procps
, tmux
}:

buildPythonPackage rec {
  pname = "libtmux";
  version = "0.11.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tmux-python";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QbKqS40la6UGZENyGEw5kXigzexp3q7ff43fKlQ9GqE=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
    procps
    tmux

    pytestCheckHook
  ];

  meta = with lib; {
    description = "Scripting library for tmux";
    homepage = "https://libtmux.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
