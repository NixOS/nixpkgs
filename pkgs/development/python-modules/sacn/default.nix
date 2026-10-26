{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage (finalAttrs: {
  pname = "sacn";
  version = "1.11.0";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-FIs5yn891haHinCmK3QQ0JQICXfnhPimMC81LXOV4Oo=";
  };

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "sacn" ];

  meta = {
    description = "Simple ANSI E1.31 (aka sACN) module";
    homepage = "https://github.com/Hundemeier/sacn";
    changelog = "https://github.com/Hundemeier/sacn/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
