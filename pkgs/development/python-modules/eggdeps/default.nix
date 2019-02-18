{ stdenv
, buildPythonPackage
, fetchPypi
, zope_interface
, zope_testing
}:

buildPythonPackage rec {
  pname = "eggdeps";
  version = "0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a99de5e4652865224daab09b2e2574a4f7c1d0d9a267048f9836aa914a2caf3a";
  };

  propagatedBuildInputs = [ zope_interface zope_testing ];

  # tests fail, see http://hydra.nixos.org/build/4316603/log/raw
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A tool which computes a dependency graph between active Python eggs";
    homepage = http://thomas-lotze.de/en/software/eggdeps/;
    license = licenses.zpl20;
  };

}
