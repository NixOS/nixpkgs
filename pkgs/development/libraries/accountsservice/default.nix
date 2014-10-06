{ stdenv, fetchurl, pkgconfig, glib, intltool, makeWrapper
, libtool, gobjectIntrospection, polkit, systemd, coreutils }:

stdenv.mkDerivation rec {
  name = "accountsservice-${version}";
  version = "0.6.38";
  
  src = fetchurl {
    url = "http://www.freedesktop.org/software/accountsservice/accountsservice-${version}.tar.xz";
    sha256 = "1ad32qv57rx9yzrvzsw0d0lh0j7adlh664lachv621wb8ya22crn";
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

  meta = with stdenv.lib; {
    description = "D-Bus interface for user account query and manipulation";
    homepage = http://www.freedesktop.org/wiki/Software/AccountsService;
    license = licenses.gpl3;
    maintainers = with maintainers; [ pSub ];
  };
}
