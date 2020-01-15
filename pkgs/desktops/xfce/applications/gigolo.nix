{ stdenv, fetchurl, python, gettext, intltool, pkgconfig, gtk, gvfs }:

stdenv.mkDerivation rec {
  p_name  = "gigolo";
  ver_maj = "0.4";
  ver_min = "2";

  src = fetchurl {
    url = "mirror://xfce/src/apps/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0r4ij0mlnp0bqq44pyrdcpz18r1zwsksw6w5yc0jzgg7wj7wfgsm";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ python gettext intltool gtk gvfs];

  meta = {
    homepage = "https://goodies.xfce.org/projects/applications/${p_name}";
    description = "A frontend to easily manage connections to remote filesystems";
    platforms = stdenv.lib.platforms.linux;
  };
}
