{ mkXfceDerivation, exo, gtk3, libgudev, libxfce4ui, libxfce4util, xfconf }:

mkXfceDerivation {
  category = "xfce";
  pname = "thunar-volman";
  version = "4.16.0";

  buildInputs = [ exo gtk3 libgudev libxfce4ui libxfce4util xfconf ];

  sha256 = "002nkxsvcq384dgpj7lv3bmb21ks64hsq13l67z1dcjbj51hzl03";

  odd-unstable = false;

  meta = {
    description = "Thunar extension for automatic management of removable drives and media";
  };
}
