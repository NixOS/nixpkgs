{ lib, stdenv, fetchurl, fetchpatch, autoreconfHook, pkg-config, help2man, python3,
  alsa-lib, xlibsWrapper, libxslt, systemd, libusb-compat-0_1, libftdi1 }:

stdenv.mkDerivation rec {
  pname = "lirc";
  version = "0.10.1";

  src = fetchurl {
    url = "mirror://sourceforge/lirc/${pname}-${version}.tar.bz2";
    sha256 = "1whlyifvvc7w04ahq07nnk1h18wc8j7c6wnvlb6mszravxh3qxcb";
  };

  patches = [
    # Fix installation of Python bindings
    (fetchpatch {
      url = "https://sourceforge.net/p/lirc/tickets/339/attachment/0001-Fix-Python-bindings.patch";
      sha256 = "088a39x8c1qd81qwvbiqd6crb2lk777wmrs8rdh1ga06lglyvbly";
    })

    # Add a workaround for linux-headers-5.18 until upstream adapts:
    #   https://sourceforge.net/p/lirc/git/merge-requests/45/
    ./linux-headers-5.18.patch
  ];

  postPatch = ''
    patchShebangs .

    # fix overriding PYTHONPATH
    sed -i 's,^PYTHONPATH *= *,PYTHONPATH := $(PYTHONPATH):,' \
      Makefile.in
    sed -i 's,PYTHONPATH=,PYTHONPATH=$(PYTHONPATH):,' \
      doc/Makefile.in

    # Pull fix for new pyyaml pending upstream inclusion
    #   https://sourceforge.net/p/lirc/git/merge-requests/39/
    substituteInPlace python-pkg/lirc/database.py --replace 'yaml.load(' 'yaml.safe_load('
  '';

  preConfigure = ''
    # use empty inc file instead of a from linux kernel generated one
    touch lib/lirc/input_map.inc
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config help2man
    (python3.withPackages (p: with p; [ pyyaml setuptools ])) ];

  buildInputs = [ alsa-lib xlibsWrapper libxslt systemd libusb-compat-0_1 libftdi1 ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-systemdsystemunitdir=$(out)/lib/systemd/system"
    "--enable-uinput" # explicit activation because build env has no uinput
    "--enable-devinput" # explicit activation because build env has no /dev/input
    "--with-lockdir=/run/lirc/lock" # /run/lock is not writable for 'lirc' user
  ];

  installFlags = [
    "sysconfdir=$out/etc"
    "localstatedir=$TMPDIR"
  ];

  meta = with lib; {
    description = "Allows to receive and send infrared signals";
    homepage = "https://www.lirc.org/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
