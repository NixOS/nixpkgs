{
  buildPythonPackage,
  lib,
  fetchPypi,
  numpy,
}:
let
  pname = "eventkit";
  version = "1.0.3";
  hash = "sha256-mUl/bzxjilD/dhby+M2Iexi7/zdl3BvYaBVU2xRnyTM=";
in
buildPythonPackage {
  format = "setuptools";
  inherit pname version;

  src = fetchPypi { inherit pname version hash; };

  propagatedBuildInputs = [ numpy ];

  meta = {
    homepage = "https://github.com/erdewit/eventkit";
    description = "Event-driven data pipelines";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ cab404 ];
  };
}
