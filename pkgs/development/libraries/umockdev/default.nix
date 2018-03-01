{ stdenv, fetchFromGitHub, automake, autoconf, libtool, gtk-doc
, pkgconfig, glib, systemd, libgudev, vala }:

stdenv.mkDerivation rec {
  name = "umockdev-${version}";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "martinpitt";
    repo = "umockdev";
    rev = version;
    sha256 ="1gpk2f03nad4qv084hx7549d68cqc1xibxm0ncanafm5xjz1hp55";
  };

  buildInputs = [ glib systemd libgudev ];
  nativeBuildInputs = [ automake autoconf libtool gtk-doc pkgconfig vala ];

  preConfigure = "NOCONFIGURE=1 ./autogen.sh";

  meta = with stdenv.lib; {
    description = "Mock hardware devices for creating unit tests";
    license = licenses.lgpl2;
    maintainers = [ maintainers.ndowens ];
  };
}
