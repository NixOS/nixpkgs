{
  buildDunePackage,
  dune-configurator,
  lablgtk3,
  librsvg,
  pkg-config,
}:

buildDunePackage {
  pname = "lablgtk3-rsvg2";

  inherit (lablgtk3) version src;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    lablgtk3
    librsvg
  ];

  meta = lablgtk3.meta // {
    description = "OCaml interface to Gnome rsvg2 library";
  };
}
