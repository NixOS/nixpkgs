{ lib
, fetchPypi
, buildPythonPackage
, astropy }:

buildPythonPackage rec {
  pname = "radio_beam";
  version = "0.3.1";

  doCheck = false; # the tests requires several pytest plugins that are not in nixpkgs

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wgd9dyz3pcc9ighkclb6qfyshwbg35s57lz6k62jhcxpvp8r5zb";
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


