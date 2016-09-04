{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  release = "8.6";
  version = "${release}.6";

  src = fetchurl {
    url = "mirror://sourceforge/tcl/tcl${version}-src.tar.gz";
    sha256 = "01zypqhy57wvh1ikk28bg733sk5kf4q568pq9v6fvcz4h6bl0rd2";
  };
})
