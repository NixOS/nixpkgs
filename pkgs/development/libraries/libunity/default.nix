{ stdenv, fetchurl, pkgconfig, automake, autoconf, libtool
, glib, vala, dee, gobjectIntrospection, libdbusmenu
, gtk3, intltool, gnome-common, python3, icu }:

stdenv.mkDerivation rec {
  pname = "libunity";
  version = "7.1.4";

  name = "${pname}-${version}";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://launchpad.net/ubuntu/+archive/primary/+files/${pname}_${version}+15.10.20151002.orig.tar.gz";
    sha256 = "1sf98qcjkxfibxk03firnc12dm6il8jzaq5763qam8ydg4li4gij";
  };

  nativeBuildInputs = [
    autoconf
    automake
    gnome-common
    gobjectIntrospection
    intltool
    libtool
    pkgconfig
    python3
    vala
  ];

  buildInputs = [
    glib
    gtk3
  ];

  propagatedBuildInputs = [ dee libdbusmenu ];

  preConfigure = "NOCONFIGURE=1 ./autogen.sh";

  configureFlags = [
    "--disable-static"
    "--with-pygi-overrides-dir=$(out)/${python3.sitePackages}/gi/overrides"
  ];

  NIX_LDFLAGS = "-L${icu}/lib";

  meta = with stdenv.lib; {
    description = "A library for instrumenting and integrating with all aspects of the Unity shell";
    homepage = https://launchpad.net/libunity;
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ worldofpeace ];
  };
}
