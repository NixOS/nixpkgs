{
  pkgs,
  buildPythonPackage,
  setuptools,
}:

buildPythonPackage {
  inherit (pkgs.jsonnet) pname version src;
  pyproject = true;

  build-system = [ setuptools ];

  pythonImportsCheck = [ "_jsonnet" ];

  meta = {
    inherit (pkgs.jsonnet.meta)
      description
      maintainers
      license
      homepage
      ;
  };
}
