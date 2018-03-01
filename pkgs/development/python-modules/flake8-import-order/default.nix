{ lib, buildPythonPackage, fetchPypi, isPy3k, enum34, pycodestyle, pytest, flake8, pylama }:

buildPythonPackage rec {
  pname = "flake8-import-order";
  version = "0.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "60ea6674c77e4d916071beabf2b31b9b45e2f5b3bbda48a34db65766a5b25678";
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
