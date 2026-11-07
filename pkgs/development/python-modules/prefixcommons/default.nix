{
  lib,
  fetchPypi,
  buildPythonPackage,
  click,
  poetry-core,
  pytest-logging,
  pyyaml,
  requests,
}:

buildPythonPackage rec {
  pname = "prefixcommons";
  version = "0.1.12";
  pyproject = true;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IsTi03tjSHs6tI8ElbcPFFZMs0ahUiDyORnrDBhR9p8=";
  };

  build-system = [ poetry-core ];
  propagatedBuildInputs = [
    click
    pyyaml
    pytest-logging
    requests
  ];

  pythonImportsCheck = [ "prefixcommons" ];

  meta = {
    description = "A Python API for working with ID prefixes";
    homepage = "https://github.com/prefixcommons/prefixcommons-py";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
}
