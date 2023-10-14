{ buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "font-roboto";
  version = "0.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-i8kTa/RmCfuxOvR4MBZ5mxTiPdopSmF5EXHefqLsRX8=";
  };

  # TODO FIXME
  doCheck = false;

  meta = {
    description = "Roboto is a neo-grotesque sans-serif font family designed by Google for the Android mobile OS.";
    homepage = "https://github.com/pimoroni/fonts-python";
  };
}
