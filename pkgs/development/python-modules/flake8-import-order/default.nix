{ lib, buildPythonPackage, fetchPypi, isPy3k, enum34, pycodestyle, pytest, flake8, pylama }:

buildPythonPackage rec {
  pname = "flake8-import-order";
  version = "0.18.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4jlB+JLaPgwJ1xG6u7DHO8c1JC6bIWtyZhZ1ipINkA4=";
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
