{ stdenv, fetchurl, fetchpatch, autoreconfHook, pkgconfig, help2man, python3,
  alsaLib, xlibsWrapper, libxslt, systemd, libusb-compat-0_1, libftdi1 }:

stdenv.mkDerivation rec {
  name = "lirc-0.10.1";

  src = fetchurl {
    url = "mirror://sourceforge/lirc/${name}.tar.bz2";
    sha256 = "1whlyifvvc7w04ahq07nnk1h18wc8j7c6wnvlb6mszravxh3qxcb";
  };

  # Fix installation of Python bindings
  patches = [ (fetchpatch {
    url = "https://sourceforge.net/p/lirc/tickets/339/attachment/0001-Fix-Python-bindings.patch";
    sha256 = "088a39x8c1qd81qwvbiqd6crb2lk777wmrs8rdh1ga06lglyvbly";
  }) ];

  postPatch = ''
    patchShebangs .

    # fix overriding PYTHONPATH
    sed -i 's,^PYTHONPATH *= *,PYTHONPATH := $(PYTHONPATH):,' \
      Makefile.in
    sed -i 's,PYTHONPATH=,PYTHONPATH=$(PYTHONPATH):,' \
      doc/Makefile.in
  '';

  preConfigure = ''
    # use empty inc file instead of a from linux kernel generated one
    touch lib/lirc/input_map.inc
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig help2man
    (python3.withPackages (p: with p; [ pyyaml setuptools ])) ];

  buildInputs = [ alsaLib xlibsWrapper libxslt systemd libusb-compat-0_1 libftdi1 ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-systemdsystemunitdir=$(out)/lib/systemd/system"
    "--enable-uinput" # explicit activation because build env has no uinput
    "--enable-devinput" # explicit activation because build env has no /dev/input
  ];

  installFlags = [
    "sysconfdir=$out/etc"
    "localstatedir=$TMPDIR"
  ];

  meta = with stdenv.lib; {
    description = "Allows to receive and send infrared signals";
    homepage = "https://www.lirc.org/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
