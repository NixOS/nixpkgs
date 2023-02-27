{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "markuppy";
  version = "1.14";

  src = fetchPypi {
    pname = "MarkupPy";
    inherit version;
    sha256 = "sha256-Gt7iwKVCrzeP6EVI/29rAWjzy39Ca0aWEDiivPqtDV8=";
  };

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "MarkupPy" ];

  meta = with lib; {
    description = "An HTML/XML generator";
    homepage = "https://github.com/tylerbakke/MarkupPy";
    license = licenses.mit;
    maintainers = with maintainers; [ sephi ];
  };
}
