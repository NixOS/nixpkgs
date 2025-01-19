{
  lib,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "markuppy";
  version = "1.14";
  format = "setuptools";

  src = fetchPypi {
    pname = "MarkupPy";
    inherit version;
    hash = "sha256-Gt7iwKVCrzeP6EVI/29rAWjzy39Ca0aWEDiivPqtDV8=";
  };

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "MarkupPy" ];

  meta = {
    description = "HTML/XML generator";
    homepage = "https://github.com/tylerbakke/MarkupPy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sephi ];
  };
}
