{ mkXfceDerivation, lib, python3, intltool, gettext,
 gtk3, libxfce4ui, libxfce4util, pango, harfbuzz, gdk-pixbuf, atk }:

let
  pythonEnv = python3.withPackages(ps: [ ps.pygobject3 ps.psutil ]);
  makeTypelibPath = lib.makeSearchPathOutput "lib/girepository-1.0" "lib/girepository-1.0";
in mkXfceDerivation {
  category = "apps";
  pname = "xfce4-panel-profiles";
  version = "1.0.14";

  sha256 = "sha256-mGA70t2U4mqEbcrj/DDsPl++EKWyZ8YXzKzzVOrH5h8=";

  nativeBuildInputs = [ intltool gettext ];
  propagatedBuildInputs = [ pythonEnv ];

  configurePhase = ''
    ./configure --prefix=$out
  '';

  postFixup = ''
    wrapProgram $out/bin/xfce4-panel-profiles \
      --set GI_TYPELIB_PATH ${makeTypelibPath [ gtk3 libxfce4ui libxfce4util pango harfbuzz gdk-pixbuf atk ]}
  '';

  meta = with lib; {
    description = "Simple application to manage Xfce panel layouts";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
