{ lib, mkXfceDerivation, automakeAddFlags, gtk3, libxfce4ui, libxfce4util, xfce4-panel }:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-dict";
  version = "0.8.4";

  sha256 = "sha256-UEkHB+i6hkTTjX62GCnr4uiCdZANuffSx2Nb2DF/pT4=";

  patches = [ ./configure-gio.patch ];

  nativeBuildInputs = [ automakeAddFlags ];

  postPatch = ''
    automakeAddFlags lib/Makefile.am libdict_la_CFLAGS GIO_CFLAGS
  '';

  buildInputs = [ gtk3 libxfce4ui libxfce4util xfce4-panel ];

  meta = with lib; {
    description = "A Dictionary Client for the Xfce desktop environment";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
