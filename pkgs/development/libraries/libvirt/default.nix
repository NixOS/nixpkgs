{ stdenv, fetchurl, fetchpatch
, pkgconfig, makeWrapper
, coreutils, libxml2, gnutls, devicemapper, perl, python2, attr
, iproute, iptables, readline, lvm2, utillinux, systemd, libpciaccess, gettext
, libtasn1, ebtables, libgcrypt, yajl, pmutils, libcap_ng, libapparmor
, dnsmasq, libnl, libpcap, libxslt, xhtml1, numad, numactl, perlPackages
, curl, libiconv, gmp, xen, zfs, parted
}:

with stdenv.lib;

# if you update, also bump pythonPackages.libvirt or it will break
stdenv.mkDerivation rec {
  name = "libvirt-${version}";
  version = "3.6.0";

  src = fetchurl {
    url = "http://libvirt.org/sources/${name}.tar.xz";
    sha256 = "0gcyql5dp6j370kvik9hjhxirrg89m7l1q52yq0g75h7jpv9fb1s";
  };

  patches = [ ./build-on-bsd.patch ];

  nativeBuildInputs = [ makeWrapper pkgconfig ];
  buildInputs = [
    libxml2 gnutls perl python2 readline gettext libtasn1 libgcrypt yajl
    libxslt xhtml1 perlPackages.XMLXPath curl libpcap
  ] ++ optionals stdenv.isLinux [
    libpciaccess devicemapper lvm2 utillinux systemd libnl numad zfs
    libapparmor libcap_ng numactl xen attr parted
  ] ++ optionals stdenv.isDarwin [
     libiconv gmp
  ];

  preConfigure = optionalString stdenv.isLinux ''
    PATH=${stdenv.lib.makeBinPath [ iproute iptables ebtables lvm2 systemd ]}:$PATH
    substituteInPlace configure \
      --replace 'as_dummy="/bin:/usr/bin:/usr/sbin"' 'as_dummy="${numad}/bin"'

    # the path to qemu-kvm will be stored in VM's .xml and .save files
    # do not use "''${qemu_kvm}/bin/qemu-kvm" to avoid bound VMs to particular qemu derivations
    substituteInPlace src/qemu/qemu_capabilities.c \
      --replace '"/usr/libexec/qemu-kvm"' '"/run/libvirt/nix-emulators/${if stdenv.isAarch64 then "qemu-system-aarch64" else "qemu-kvm"}"'
    substituteInPlace src/lxc/lxc_conf.c \
      --replace 'lxc_path,' '"/run/libvirt/nix-emulators/libvirt_lxc",'
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
  ] ++ optionals stdenv.isLinux [
    "--with-attr"
    "--with-apparmor"
    "--with-secdriver-apparmor"
    "--with-numad"
    "--with-macvtap"
    "--with-virtualport"
    "--with-init-script=systemd+redhat"
    "--with-storage-disk"
  ] ++ optionals (stdenv.isLinux && zfs != null) [
    "--with-storage-zfs"
  ] ++ optionals stdenv.isDarwin [
    "--with-init-script=none"
  ];

  installFlags = [
    "localstatedir=$(TMPDIR)/var"
    "sysconfdir=$(out)/var/lib"
  ];

  postInstall = ''
    sed -i 's/ON_SHUTDOWN=suspend/ON_SHUTDOWN=''${ON_SHUTDOWN:-suspend}/' $out/libexec/libvirt-guests.sh
    substituteInPlace $out/libexec/libvirt-guests.sh \
      --replace "$out/bin" "${gettext}/bin" \
      --replace "lock/subsys" "lock"
    sed -e "/gettext\.sh/a \\\n# Added in nixpkgs:\ngettext() { \"${gettext}/bin/gettext\" \"\$@\"; }" \
        -i "$out/libexec/libvirt-guests.sh"

    substituteInPlace $out/lib/systemd/system/libvirtd.service --replace /bin/kill ${coreutils}/bin/kill
  '' + optionalString stdenv.isLinux ''
    rm $out/lib/systemd/system/{virtlockd,virtlogd}.*
    wrapProgram $out/sbin/libvirtd \
      --prefix PATH : ${makeBinPath [ iptables iproute pmutils numad numactl ]}
  '';

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = "-fno-stack-protector";

  meta = {
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
