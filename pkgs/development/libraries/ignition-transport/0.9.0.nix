{ stdenv, fetchurl, callPackage, ... } @ args :

callPackage ./generic.nix (args // rec {
  version = "0.9.0";
  src = fetchurl {
    url = "http://gazebosim.org/distributions/ign-transport/releases/ignition-transport-${version}.tar.bz2";
    sha256 = "15a8lkxri8q2gc7h0pj1dg2kivhy46v8d3mlxpjy90l77788bw1z";
  };
})
