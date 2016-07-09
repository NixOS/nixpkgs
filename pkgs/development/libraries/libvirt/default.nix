{ stdenv, fetchurl, fetchpatch
, pkgconfig, makeWrapper
, libxml2, gnutls, devicemapper, perl, python
, iproute, iptables, readline, lvm2, utillinux, udev, libpciaccess, gettext
, libtasn1, ebtables, libgcrypt, yajl, pmutils, libcap_ng
, dnsmasq, libnl, libpcap, libxslt, xhtml1, numad, numactl, perlPackages
, curl, libiconv, gmp, xen, zfs, systemd
}:
# if you update, also bump pythonPackages.libvirt or it will break
stdenv.mkDerivation rec {
  name = "libvirt-${version}";
  version = "1.3.5";

  src = fetchurl {
    url = "http://libvirt.org/sources/${name}.tar.gz";
    sha256 = "1j2ar5gb6xcyw1mlpm0mfpiri6www9k5myaqjina87a3xd23r8lk";
  };

  patches = [
    ./build-on-bsd.patch
    (fetchpatch {  # see http://security.libvirt.org/2016/0001.html
      name = "libvirt-CVE-2016-5008";
      url = "https://libvirt.org/git/?p=libvirt.git;a=patch;h=46d27cde24b495320dc28bbf79134e0ce48c11b8";
      sha256 = "19f6f8df57cr0sn6a1xf9ixa6vgjqmmzjf617pdj5gxy18aqn2pg";
    })
  ];

  nativeBuildInputs = [ makeWrapper pkgconfig ];
  buildInputs = [
    libxml2 gnutls perl python readline
    gettext libtasn1 libgcrypt yajl
    libxslt xhtml1 perlPackages.XMLXPath curl libpcap
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    libpciaccess devicemapper lvm2 utillinux udev libcap_ng
    libnl numad numactl xen zfs systemd
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
     libiconv gmp
  ];

  preConfigure = stdenv.lib.optionalString stdenv.isLinux ''
    PATH=${iproute}/sbin:${iptables}/sbin:${ebtables}/sbin:${lvm2}/sbin:${udev}/sbin:$PATH
    substituteInPlace configure --replace 'as_dummy="/bin:/usr/bin:/usr/sbin"' 'as_dummy="${numad}/bin"'
  '' + ''
    PATH=${dnsmasq}/bin:$PATH
    patchShebangs . # fixes /usr/bin/python references
  '';

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/var/lib"
    "--with-libpcap"
    "--with-vmware"
    "--with-vbox"
    "--with-test"
    "--with-esx"
    "--with-remote"
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    "--with-numad"
    "--with-macvtap"
    "--with-virtualport"
    "--with-init-script=redhat"
    "--with-storage-zfs"
    "--with-systemd-daemon"
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    "--with-init-script=none"
  ];

  installFlags = [
    "localstatedir=$(TMPDIR)/var"
    "sysconfdir=$(out)/var/lib"
  ];

  postInstall = ''
    sed -i 's/ON_SHUTDOWN=suspend/ON_SHUTDOWN=''${ON_SHUTDOWN:-suspend}/' $out/libexec/libvirt-guests.sh
    substituteInPlace $out/libexec/libvirt-guests.sh \
      --replace "$out/bin" "${gettext}/bin"
  '' + stdenv.lib.optionalString stdenv.isLinux ''
    wrapProgram $out/sbin/libvirtd \
      --prefix PATH : ${iptables}/sbin:${iproute}/sbin:${pmutils}/bin:${numad}/bin:${numactl}/bin
  '';

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = "-fno-stack-protector";

  meta = with stdenv.lib; {
    homepage = http://libvirt.org/;
    repositories.git = git://libvirt.org/libvirt.git;
    description = ''
      A toolkit to interact with the virtualization capabilities of recent
      versions of Linux (and other OSes)
    '';
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
