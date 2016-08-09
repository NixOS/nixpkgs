{ stdenv, fetchurl, pkgconfig, glib, intltool, makeWrapper
, libtool, gobjectIntrospection, polkit, systemd, coreutils }:

stdenv.mkDerivation rec {
  name = "accountsservice-${version}";
  version = "0.6.40";
  
  src = fetchurl {
    url = "http://www.freedesktop.org/software/accountsservice/accountsservice-${version}.tar.xz";
    sha256 = "0ayb3y3l25dmwxlh9g071h02mphjfbkvi2k5f635bayb01k7akzh";
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
    platforms = with platforms; linux;
  };
}
