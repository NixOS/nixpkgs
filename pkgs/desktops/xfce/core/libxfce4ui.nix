{ stdenv, fetchurl, pkgconfig, intltool, gtk, libxfce4util, xfconf
, libglade, libstartup_notification }:

stdenv.mkDerivation rec {
  p_name  = "libxfce4ui";
  ver_maj = "4.10";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1qm31s6568cz4c8rl9fsfq0xmf7pldxm0ki62gx1cpybihlgmfd2";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  #TODO: gladeui
  # Install into our own prefix instead.
  preConfigure =
    ''
      configureFlags="--with-libglade-module-path=$out/lib/libglade/2.0"
    '';

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util xfconf libglade
      libstartup_notification
    ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.xfce.org/;
    description = "Basic GUI library for Xfce";
    license = "LGPLv2+";
  };
}
