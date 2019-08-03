{ buildDunePackage, gtksourceview, lablgtk3 }:

buildDunePackage rec {
  pname = "lablgtk3-sourceview3";
  buildInputs = lablgtk3.buildInputs ++ [ gtksourceview ];
  propagatedBuildInputs = [ lablgtk3 ];
  inherit (lablgtk3) src version meta nativeBuildInputs;
}
