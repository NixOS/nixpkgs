{
  lib,
  chickenPackages_4,
}:

let
  eggs = import ./eggs.nix { inherit (chickenPackages_4) eggDerivation fetchegg; };
in

chickenPackages_4.eggDerivation rec {
  pname = "ugarit-manifest-maker";
  version = "0.1";
  name = "${pname}-${version}";

  src = chickenPackages_4.fetchegg {
    inherit version;
    name = pname;
    sha256 = "1jv8lhn4s5a3qphqd3zfwl1py0m5cmqj1h55ys0935m5f422547q";
  };

  buildInputs = with eggs; [
    matchable
    srfi-37
    fnmatch
    miscmacros
    ugarit
    numbers
  ];

  meta = {
    homepage = "https://www.kitten-technologies.co.uk/project/ugarit-manifest-maker/";
    description = "Tool for generating import manifests for Ugarit";
    mainProgram = "ugarit-manifest-maker";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
}
