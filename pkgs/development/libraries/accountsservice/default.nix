{ stdenv, fetchurl, pkgconfig, glib, intltool, makeWrapper, shadow
, libtool, gobjectIntrospection, polkit, systemd, coreutils }:

stdenv.mkDerivation rec {
  name = "accountsservice-${version}";
  version = "0.6.47";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/accountsservice/accountsservice-${version}.tar.xz";
    sha256 = "038k7p2fqqcycwbh1ik4rjlnzddkf9j9wf0risjabccqj33znkp3";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper ];

  buildInputs = [ glib intltool libtool gobjectIntrospection polkit systemd ];

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
    homepage = https://www.freedesktop.org/wiki/Software/AccountsService;
    license = licenses.gpl3;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux;
  };
}
