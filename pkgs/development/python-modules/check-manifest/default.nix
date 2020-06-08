{ stdenv, buildPythonPackage, fetchPypi, toml }:

buildPythonPackage rec {
  pname = "check-manifest";
  version = "0.42";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d8e1b0944a667dd4a75274f6763e558f0d268fde2c725e894dfd152aae23300";
  };

  propagatedBuildInputs = [ toml ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/mgedmin/check-manifest";
    description = "Check MANIFEST.in in a Python source package for completeness";
    license = licenses.mit;
    maintainers = with maintainers; [ lewo ];
    broken = true; # pep517 package doesn't exist in nixpkgs
  };
}
