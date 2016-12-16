/* This function wraps buildPythonPackage and uses pre-fetched data from PyPI to build a package.
*/
{ buildPythonPackage
, fetchurl
, fetchgit
, lib
}:


{ name
, version ? ""
, ... } @ attrs:

let
  pypi-src = fetchgit {
    url = "https://github.com/FRidh/srcs-pypi.git";
    rev = "12bc2a4cbcec42a867e4cc2fdef67e76b2c0b169";
    sha256 = "0j3fhfnj36wsm6z3r0mnsr7c90vihi1j61nwdz31dz4y2r0w2vg4";
  };

  data = import (pypi-src) {inherit name;};

  # Whether to actually use PyPI
  pypi = !(builtins.hasAttr "src" attrs || builtins.hasAttr "srcs" attrs);

  # Use Meta data from PyPI
  pypimeta = if pypi then data.meta else {};

  # Version. When specified, use that.
  # Otherwise, if src is not given and there is a PyPI source available, then use the latest version available.
  version = attrs.version or (if pypi then data.latest_version else "");
  # Use src if given. Otherwise, pick the right version via PyPI.
  src = attrs.src or attrs.srcs or (fetchurl data.versions.${version});

in buildPythonPackage ( attrs // {name = name + "-" + version; src=src; meta = pypimeta;} )
