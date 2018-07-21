{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ConfigArgParse";
  version = "0.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e6441aa58e23d3d122055808e5e2220fd742dff6e1e51082d2a4e4ed145dd788";
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
