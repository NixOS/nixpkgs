{ stdenv, fetchFromGitHub, automake, autoconf, libtool, gtk-doc
, pkgconfig, glib, systemd, libgudev, vala }:

stdenv.mkDerivation rec {
  name = "umockdev-${version}";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "martinpitt";
    repo = "umockdev";
    rev = version;
    sha256 ="0cmswac8m7zfvk6cb8k5iisqr7arnn1yhcmasri072yz0pmr6dr0";
  };

  buildInputs = [ glib systemd libgudev ];
  nativeBuildInputs = [ automake autoconf libtool gtk-doc pkgconfig vala ];

  preConfigure = "NOCONFIGURE=1 ./autogen.sh";

  meta = with stdenv.lib; {
    description = "Mock hardware devices for creating unit tests";
    license = licenses.lgpl2;
    maintainers = [ maintainers.ndowens ];
    platforms = with platforms; linux;
  };
}
