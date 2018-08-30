{ stdenv, fetchurl, alsaLib, help2man, pkgconfig, xlibsWrapper, python3
, libxslt, systemd, libusb, libftdi1 }:

stdenv.mkDerivation rec {
  name = "lirc-0.10.1";

  src = fetchurl {
    url = "mirror://sourceforge/lirc/${name}.tar.bz2";
    sha256 = "1whlyifvvc7w04ahq07nnk1h18wc8j7c6wnvlb6mszravxh3qxcb";
  };

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

  nativeBuildInputs = [ pkgconfig help2man ];

  buildInputs = [ alsaLib xlibsWrapper libxslt systemd libusb libftdi1 ]
  ++ (with python3.pkgs; [ python pyyaml setuptools ]);

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-systemdsystemunitdir=$(out)/lib/systemd/system"
    "--enable-uinput" # explicite activation because build env has no uinput
    "--enable-devinput" # explicite activation because build env has not /dev/input
  ];

  installFlags = [
    "sysconfdir=$out/etc"
    "localstatedir=$TMPDIR"
  ];

  meta = with stdenv.lib; {
    description = "Allows to receive and send infrared signals";
    homepage = http://www.lirc.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
