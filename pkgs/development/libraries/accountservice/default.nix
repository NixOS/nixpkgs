{ stdenv, fetchurl, pkgconfig, glib, intltool
, libtool, gobjectIntrospection, polkit, systemd }:

stdenv.mkDerivation rec {
  name = "accountsservice-0.6.35";
  
  src = fetchurl {
    url = http://www.freedesktop.org/software/accountsservice/accountsservice-0.6.35.tar.xz;
    sha256 = "0f1hzl6hw56xvwgmd4yvmdyj15xj1fafw45pzv3qarww7h0wg8b5";
  };

  buildInputs = [ pkgconfig glib intltool libtool
                  gobjectIntrospection polkit systemd ];

  configureFlags = [ "--with-systemdsystemunitdir=$(out)/etc/systemd/system" ];
}
