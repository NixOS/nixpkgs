{ buildDunePackage, gtksourceview, lablgtk3 }:

buildDunePackage {
  pname = "lablgtk3-sourceview3";
  buildInputs = lablgtk3.buildInputs ++ [ gtksourceview ];
  propagatedBuildInputs = [ lablgtk3 ];
  inherit (lablgtk3) src version meta nativeBuildInputs;
}
