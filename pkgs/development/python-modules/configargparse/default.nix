{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ConfigArgParse";
  version = "1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cvinm7bb03qfjpq2zhfacm0qs4ip4378nvya8x41p4wpi2q4dxz";
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
