{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ConfigArgParse";
  version = "0.15.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "558738aff623d6667aa5b85df6093ad3828867de8a82b66a6d458fb42567beb3";
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
