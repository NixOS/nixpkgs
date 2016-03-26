{ stdenv, fetchurl, callPackage, ... } @ args:

callPackage ./default.nix (args // rec {
  version = "3.7.0";
  srchash-sha256 = "07kn8bgvj9mwwinsp2cbmz11z7zw2lgnj61mi1gi1pjg7q9in98q";
})

