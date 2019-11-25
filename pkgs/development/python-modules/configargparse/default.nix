{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ConfigArgParse";
  version = "0.15.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "baaf0fd2c1c108d007f402dab5481ac5f12d77d034825bf5a27f8224757bd0ac";
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
