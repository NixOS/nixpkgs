{ stdenv, lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ConfigArgParse";
  version = "0.12.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fgkiqh6r3rbkdq3k8c48m85g52k96686rw3a6jg4lcncrkpvk98";
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
