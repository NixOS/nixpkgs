  # system-settings depends on older accountsservice version with specific patches
  # expression mostly copied from https://github.com/NixOS/nixpkgs/commit/755be7ef793cd29394d821e72656ac0276ea1c9b
  # https://github.com/ubports/system-settings/issues/65
  { stdenv, fetchurl, fetchzip, fetchpatch, pkg-config, glib, intltool, makeWrapper, shadow
, libtool, gobject-introspection, polkit, systemd, coreutils }:

let
  ubuntu-patches = fetchzip {
    url = "https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/accountsservice/0.6.45-1ubuntu1.3/accountsservice_0.6.45-1ubuntu1.3.debian.tar.xz";
    sha256 = "173vzx20x2jpax1mq80i4gn61c0l1z8aq3zyh6cr8d5w88l2ycl0";
  };
in
stdenv.mkDerivation rec {
  pname = "accountsservice";
  version = "0.6.42";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://www.freedesktop.org/software/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0zh0kjpdc631qh36plcgpwvnmh9wj8l5cki3aw5r09w6y7198r75";
  };

  nativeBuildInputs = [ pkg-config intltool libtool makeWrapper ];

  buildInputs = [ glib gobject-introspection polkit systemd ];

  configureFlags = [ "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
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
    ("${ubuntu-patches}/patches/0001-formats-locale-property.patch")
    ("${ubuntu-patches}/patches/0007-add-lightdm-support.patch")
    ("${ubuntu-patches}/patches/0011-add-background-file-support.patch")
    ("${ubuntu-patches}/patches/0016-add-input-sources-support.patch")
    ("${ubuntu-patches}/patches/0001-Move-cache-cleanup-out-into-a-common-function-and-cl.patch")
    ("${ubuntu-patches}/patches/0015-debian-nologin-path.patch")
    ("${ubuntu-patches}/patches/CVE-2018-14036.patch")

    (fetchpatch {
      url = "https://raw.githubusercontent.com/NixOS/nixpkgs/755be7ef793cd29394d821e72656ac0276ea1c9b/pkgs/development/libraries/accountsservice/no-create-dirs.patch";
      sha256 = "1rk2kyk49jk0bk14qv1l48vnqbxi4ykb2wmhy8i4j0gcdyi8lzqx";
    })
    # ./Add-nixbld-to-user-blacklist.patch ?
    ./Disable-methods-that-change-files-in-etc.patch
  ];

  preFixup = ''
    wrapProgram "$out/libexec/accounts-daemon" \
      --run "${coreutils}/bin/mkdir -p /var/lib/AccountsService/users" \
      --run "${coreutils}/bin/mkdir -p /var/lib/AccountsService/icons"
  '';

  meta = with stdenv.lib; {
    description = "D-Bus interface for user account query and manipulation";
    homepage = "https://www.freedesktop.org/wiki/Software/AccountsService";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
