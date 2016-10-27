{ stdenv, fetchurl, pkgconfig, glib, intltool, makeWrapper, shadow
, libtool, gobjectIntrospection, polkit, systemd, coreutils }:

stdenv.mkDerivation rec {
  name = "accountsservice-${version}";
  version = "0.6.43";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/accountsservice/accountsservice-${version}.tar.xz";
    sha256 = "1k6n9079001sgcwlkq0bz6mkn4m8y4dwf6hs1qm85swcld5ajfzd";
  };

  buildInputs = [ pkgconfig glib intltool libtool makeWrapper
                  gobjectIntrospection polkit systemd ];

  configureFlags = [ "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
                     "--localstatedir=/var" ];
  prePatch = ''
    substituteInPlace src/daemon.c --replace '"/usr/sbin/useradd"' '"${shadow}/bin/useradd"' \
                                   --replace '"/usr/sbin/userdel"' '"${shadow}/bin/userdel"'
    substituteInPlace src/user.c   --replace '"/usr/sbin/usermod"' '"${shadow}/bin/usermod"' \
                                   --replace '"/usr/bin/chage"' '"${shadow}/bin/chage"' \
                                   --replace '"/usr/bin/passwd"' '"${shadow}/bin/passwd"' \
                                   --replace '"/bin/cat"' '"${coreutils}/bin/cat"'
  '';

  patches = [
    ./no-create-dirs.patch
    ./Disable-methods-that-change-files-in-etc.patch
  ];

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
