{ stdenv, fetchurl, pkgconfig, glib, intltool, makeWrapper
, libtool, gobjectIntrospection, polkit, systemd, coreutils }:

stdenv.mkDerivation rec {
  name = "accountsservice-0.6.37";
  
  src = fetchurl {
    url = http://www.freedesktop.org/software/accountsservice/accountsservice-0.6.37.tar.xz;
    sha256 = "1hd58lrl698ij7w1xk3fpj8zp7h6m2hpzvfmbw9sfx4xvhv13cmh";
  };

  buildInputs = [ pkgconfig glib intltool libtool makeWrapper
                  gobjectIntrospection polkit systemd ];

  configureFlags = [ "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
                     "--localstatedir=/var" ];

  patches = [ ./no-create-dirs.patch ];
  patchFlags = "-p0";
  
  preFixup = ''
    wrapProgram "$out/libexec/accounts-daemon" \
      --run "${coreutils}/bin/mkdir -p /var/lib/AccountsService/users" \
      --run "${coreutils}/bin/mkdir -p /var/lib/AccountsService/icons"
  '';

  meta = {
    description = "D-Bus interface for user account query and manipulation";
  };
}
