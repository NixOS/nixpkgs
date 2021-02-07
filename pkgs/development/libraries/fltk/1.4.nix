{ callPackage
, fetchurl
}:

callPackage ./generic.nix rec {
  version = "1.4.x-r13121";
  src = fetchurl {
    url = "https://www.fltk.org/pub/fltk/snapshots/fltk-${version}.tar.gz";
    sha256 = "1v8wxvxcbk99i82x2v5fpqg5vj8n7g8a38g30ry7nzcjn5sf3r63";
  };
}
