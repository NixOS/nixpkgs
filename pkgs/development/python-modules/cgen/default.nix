{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytools,
  numpy,
  pytest,
}:

buildPythonPackage rec {
  pname = "cgen";
  version = "2025.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-efAeAQ1JwT5YtMqPLUmWprcXiWj18tkGJiczSArnotQ=";
  };

  nativeCheckInputs = [ pytest ];
  propagatedBuildInputs = [
    pytools
    numpy
  ];

  checkPhase = ''
    pytest
  '';

  meta = {
    description = "C/C++ source generation from an AST";
    homepage = "https://github.com/inducer/cgen";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
