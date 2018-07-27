{ lib, buildPythonPackage, fetchPypi, isPy3k, enum34, pycodestyle, pytest, flake8, pylama }:

buildPythonPackage rec {
  pname = "flake8-import-order";
  version = "0.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9be5ca10d791d458eaa833dd6890ab2db37be80384707b0f76286ddd13c16cbf";
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
