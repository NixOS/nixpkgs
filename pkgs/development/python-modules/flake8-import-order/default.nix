{ lib, buildPythonPackage, fetchFromGitHub, isPy3k, enum34, pycodestyle, pytest, flake8, pylama }:

buildPythonPackage rec {
  pname = "flake8-import-order";
  version = "0.18.1";

  src = fetchFromGitHub {
     owner = "PyCQA";
     repo = "flake8-import-order";
     rev = "0.18.1";
     sha256 = "0l1sbl056zv0lxvvm7v2q6ynbqpw2nxhybsq5pryna3727qisznq";
  };

  propagatedBuildInputs = [ pycodestyle ] ++ lib.optional (!isPy3k) enum34;

  checkInputs = [ pytest flake8 pycodestyle pylama ];

  checkPhase = ''
    pytest --strict
  '';

  meta = with lib; {
    description = "Flake8 and pylama plugin that checks the ordering of import statements";
    homepage = "https://github.com/PyCQA/flake8-import-order";
    license = with licenses; [ lgpl3 mit ];
  };
}
