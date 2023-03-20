{ lib
, buildPythonPackage
, fetchPypi
, zope_interface
, zope_testing
}:

buildPythonPackage rec {
  pname = "tl-eggdeps";
  version = "1.0";

  src = fetchPypi {
    inherit version;
    pname = "tl.eggdeps";
    sha256 = "a094ed7961a3dd38fcaaa69cf7a58670038acdff186360166d9e3d964b7a7323";
  };

  propagatedBuildInputs = [ zope_interface zope_testing ];

  # tests fail, see https://hydra.nixos.org/build/4316603/log/raw
  doCheck = false;

  meta = with lib; {
    description = "A tool which computes a dependency graph between active Python eggs";
    homepage = "http://thomas-lotze.de/en/software/eggdeps/";
    license = licenses.zpl20;
  };

}
