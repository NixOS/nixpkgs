{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ConfigArgParse";
  version = "0.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "149fy4zya0rsnlkvxbbq43cyr8lscb5k4pj1m6n7f1grwcmzwbif";
  };

  # no tests in tarball
  doCheck = false;

  meta = with lib; {
    description = "A drop-in replacement for argparse";
    homepage = https://github.com/zorro3/ConfigArgParse;
    license = licenses.mit;
    maintainers = [ maintainers.willibutz ];
  };
}
