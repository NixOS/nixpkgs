{
  buildDunePackage,
  gtkspell3,
  lablgtk3,
}:

buildDunePackage {
  pname = "lablgtk3-gtkspell3";
  buildInputs = [ gtkspell3 ] ++ lablgtk3.buildInputs;
  propagatedBuildInputs = [ lablgtk3 ];
  inherit (lablgtk3)
    src
    version
    meta
    nativeBuildInputs
    ;
}
