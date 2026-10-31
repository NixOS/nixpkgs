{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools,
}:
buildPythonPackage (finalAttrs: {
  pname = "greek-accentuation";
  version = "1.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "greek-accentuation";
    inherit (finalAttrs) version;
    hash = "sha256-l2HZXdqlLubvy2bWhhZVYGMpF0DXVKTDFehkcGF5xdk=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "greek_accentuation" ];

  meta = {
    description = "Python 3 library for accenting (and analyzing the accentuation of) Ancient Greek words";
    homepage = "https://github.com/jtauber/greek-accentuation";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kmein ];
  };
})
