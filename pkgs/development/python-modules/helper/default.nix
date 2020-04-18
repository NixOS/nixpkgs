{ stdenv, buildPythonPackage, fetchPypi, pyyaml, mock }:

buildPythonPackage rec {
  pname = "helper";
  version = "2.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0p56dvjpaz9wnr0ik2wmvgqjf9ji180bhjky7q272l5dan94lgd6";
  };

  checkInputs = [ mock ];
  propagatedBuildInputs = [ pyyaml ];

  # No tests in the pypi tarball
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Development library for quickly writing configurable applications and daemons";
    homepage = "https://helper.readthedocs.org/";
    license = licenses.bsd3;
  };
}
