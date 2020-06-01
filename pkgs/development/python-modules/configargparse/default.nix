{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ConfigArgParse";
  version = "1.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p1pzpf5qpf80bfxsx1mbw9blyhhypjvhl3i60pbmhfmhvlpplgd";
  };

  # no tests in tarball
  doCheck = false;

  meta = with lib; {
    description = "A drop-in replacement for argparse";
    homepage = "https://github.com/zorro3/ConfigArgParse";
    license = licenses.mit;
    maintainers = [ maintainers.willibutz ];
  };
}
