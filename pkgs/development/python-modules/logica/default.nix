{
  lib,
  buildPythonPackage,
  fetchPypi,
  duckdb,
  setuptools,
}:

buildPythonPackage rec {
  pname = "logica";
  version = "1.3.14159265358";

  # This package is not buildable from the GitHub repo (no setup.py),
  # so we build from the pypi sdist. https://github.com/EvgSkv/logica
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BC3pjy5jde/2MWvR2oMbli0C4GssV7hdIQ82Hpc2RAM=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"logica/README.md"' '"README.md"'
  '';

  build-system = [ setuptools ];

  dependencies = [ duckdb ];

  pythonImportsCheck = [ "logica" ];

  meta = {
    description = "Declarative logic programming language for data manipulation";
    homepage = "https://logica.dev/";
    license = [ lib.licenses.asl20 ];
    maintainers = [ lib.maintainers.rskew ];
  };
}
