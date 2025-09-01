{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  pydantic,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "pydantic-argparse-extensible";
  version = "1.3.6";
  pyproject = true;

  src = fetchPypi {
    pname = "pydantic_argparse_extensible";
    inherit version;
    hash = "sha256-DLE2eFrofCDcEPrn5g/mZlxNidVXThUumWV+u+yyvOI=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    pydantic
  ];

  pythonImportsCheck = [
    "pydantic_argparse_extensible"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Typed wrapper around argparse using pydantic models";
    homepage = "https://pypi.org/project/pydantic-argparse-extensible";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers._9999years ];
  };
}
