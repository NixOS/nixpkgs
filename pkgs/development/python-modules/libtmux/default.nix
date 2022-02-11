{ lib
, fetchFromGitHub
, buildPythonPackage
, poetry-core
, pytestCheckHook
, pkgs
}:

buildPythonPackage rec {
  pname = "libtmux";
  version = "0.10.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tmux-python";
    repo = pname;
    rev = "v${version}";
    hash = "sha256:0syj8m4x2mcq96b76b7h75dsmcai22m15pfgkk90rpg7rp6sn772";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
    pkgs.procps
    pkgs.tmux
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Scripting library for tmux";
    homepage = "https://libtmux.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
