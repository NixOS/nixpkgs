{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools,
}:
buildPythonPackage rec {
  pname = "greek-accentuation";
  version = "1.2.0";
  pyproject = true;
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-l2HZXdqlLubvy2bWhhZVYGMpF0DXVKTDFehkcGF5xdk=";
  };

  build-system = [ setuptools ];
  meta = {
    description = "Python 3 library for accenting (and analyzing the accentuation of) Ancient Greek words";
    homepage = "https://github.com/jtauber/greek-accentuation";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kmein ];
  };
}
