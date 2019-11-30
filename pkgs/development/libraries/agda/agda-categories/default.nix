{ lib, agda, fetchFromGitHub, AgdaStdlib }:

agda.mkDerivation (self: rec {
  version = "0.1";
  pname = "agda-categories";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "agda";
    repo = pname;
    rev = "release/v${version}";
    sha256 = "0m4pjy92jg6zfziyv0bxv5if03g8k4413ld8c3ii2xa8bzfn04m2";
  };

  # Remove the dependency in the agda file as this breaks the current agda infrastructure
  patches = [ ./depend.patch ];
  sourceDirectories = [ "Categories" "Relation" ];

  buildDepends = [ AgdaStdlib ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A new Categories library";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ alexarice ];
  };
})
