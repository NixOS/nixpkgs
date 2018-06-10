{ lib, buildPythonPackage, fetchPypi, isPy3k, enum34, pycodestyle, pytest, flake8, pylama }:

buildPythonPackage rec {
  pname = "flake8-import-order";
  version = "0.17.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "68d430781a9ef15c85a0121500cf8462f1a4bc7672acb2a32bfdbcab044ae0b7";
  };

  propagatedBuildInputs = [ pycodestyle ] ++ lib.optional (!isPy3k) enum34;

  checkInputs = [ pytest flake8 pycodestyle pylama ];

  checkPhase = ''
    pytest --strict
  '';

  meta = with lib; {
    description = "Flake8 and pylama plugin that checks the ordering of import statements";
    homepage = https://github.com/PyCQA/flake8-import-order;
    license = with licenses; [ lgpl3 mit ];
  };
}
