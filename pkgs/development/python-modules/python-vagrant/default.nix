{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "0.5.15";
  pname = "python-vagrant";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ikrh6canhcxg5y7pzmkcnnydikppv7s6sm9prfx90nk0ac8m6mg";
  };

  # The tests try to connect to qemu
  doCheck = false;

  meta = {
    description = "Python module that provides a thin wrapper around the vagrant command line executable";
    homepage = https://github.com/todddeluca/python-vagrant;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.pmiddend ];
  };
}
