{ mkXfceDerivation, gtk2 ? null, gtk3, libxfce4ui, libxfce4util }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "garcon";
  version = "0.6.1";

  sha256 = "19k8bwn29x7hkg882pxv5xxmrbfagdqgkxg166pwz2k0prab6hl8";

  patches = [ ./12700.patch ./13785.patch ];
  buildInputs = [ gtk2 gtk3 libxfce4ui libxfce4util ];
}
