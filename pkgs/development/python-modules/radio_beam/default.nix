{ lib
, fetchPypi
, buildPythonPackage
, astropy }:

buildPythonPackage rec {
  pname = "radio_beam";
  version = "0.2";

  doCheck = false; # the tests requires several pytest plugins that are not in nixpkgs

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gbnwnk89n8z0xwn41rc7wpr0fwrzkvxficyki3dyqbxq7y3qfrv";
  };

  propagatedBuildInputs = [ astropy ];

  meta = {
    description = "Tools for Beam IO and Manipulation";
    homepage = http://radio-astro-tools.github.io;
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ smaret ];
  };
}


