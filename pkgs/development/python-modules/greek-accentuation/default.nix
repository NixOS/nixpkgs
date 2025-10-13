{
  buildPythonPackage,
  lib,
  fetchPypi,
}:
buildPythonPackage rec {
  pname = "greek-accentuation";
  version = "1.2.0";
  format = "setuptools";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-l2HZXdqlLubvy2bWhhZVYGMpF0DXVKTDFehkcGF5xdk=";
  };
  meta = with lib; {
    description = "Python 3 library for accenting (and analyzing the accentuation of) Ancient Greek words";
    homepage = "https://github.com/jtauber/greek-accentuation";
    license = licenses.mit;
    maintainers = with maintainers; [ kmein ];
  };
}
