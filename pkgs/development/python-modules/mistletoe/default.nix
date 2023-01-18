{ lib
, isPy3k
, fetchPypi
, buildPythonPackage }:

buildPythonPackage rec {
  pname = "mistletoe";
  version = "1.0.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+g6cV+IFDP1orjBOT5xeHmk1dMxf2DI9szRSlJ1oJmE=";
  };

  meta = with lib; {
    description = "A fast, extensible Markdown parser in pure Python.";
    homepage = "https://github.com/miyuchina/mistletoe";
    license = licenses.mit;
    maintainers = with maintainers; [ eadwu ];
  };
}
