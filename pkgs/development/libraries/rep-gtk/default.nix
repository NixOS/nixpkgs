{ lib
, stdenv
, fetchurl
, autoreconfHook
, gtk2
, librep
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "rep-gtk";
  version = "0.90.8.3";

  src = fetchurl {
    url = "https://download.tuxfamily.org/librep/${pname}/${pname}_${version}.tar.xz";
    sha256 = "0hgkkywm8zczir3lqr727bn7ybgg71x9cwj1av8fykkr8pdpard9";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    gtk2
    librep
  ];

  patchPhase = ''
    sed -e 's|installdir=$(repexecdir)|installdir=$(libdir)/rep|g' -i Makefile.in
  '';

  meta = with lib; {
    homepage = "http://sawfish.tuxfamily.org";
    description = "GTK bindings for librep";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
# TODO: investigate fetchFromGithub
