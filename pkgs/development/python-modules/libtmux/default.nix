{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, poetry-core
, pytestCheckHook
, procps
, tmux
}:

buildPythonPackage rec {
  pname = "libtmux";
  version = "0.13.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tmux-python";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-u08lxVMuyO5CwFbmxn69QqdSWcvGaSMZgizRJlsHa0k=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
    procps
    tmux

    pytestCheckHook
  ];

  pytestFlagsArray = lib.optionals stdenv.isDarwin [ "--ignore=tests/test_test.py" ];

  pythonImportsCheck = [ "libtmux" ];

  meta = with lib; {
    description = "Scripting library for tmux";
    homepage = "https://libtmux.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
