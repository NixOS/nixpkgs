{
  lib,
  fetchPypi,
  buildPythonPackage,
  six,
}:

buildPythonPackage rec {
  pname = "gviz_api";
  version = "1.10.0";
  format = "wheel";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    sha256 = "a05055fed8c279f34f4b496eace7648c7fe9c1b06851e8a36e748541f1adbb05";
  };

  propagatedBuildInputs = [ six ];

  meta = {
    description = "Python API for Google Visualization";
    homepage = "https://developers.google.com/chart/interactive/docs/dev/gviz_api_lib";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ndl ];
  };
}
