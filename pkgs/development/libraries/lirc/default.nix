{ stdenv, fetchurl, alsaLib, bash, help2man, pkgconfig, xlibsWrapper
, python3Packages, libxslt, systemd, libusb, libftdi1 }:

stdenv.mkDerivation rec {
  name = "lirc-0.9.4d";

  src = fetchurl {
    url = "mirror://sourceforge/lirc/${name}.tar.bz2";
    sha256 = "1as19rnaz9vpp58kbk9q2lch51vf2fdi27bl19f8d6s8bg1ii3y6";
  };

  postPatch = ''
    patchShebangs .

    # fix overriding PYTHONPATH
    sed -i 's,PYTHONPATH=,PYTHONPATH=$(PYTHONPATH):,' \
      doc/Makefile.in
  '';

  preConfigure = ''
    # use empty inc file instead of a from linux kernel generated one
    touch lib/lirc/input_map.inc
  '';

  nativeBuildInputs = [ pkgconfig help2man ];

  buildInputs = [ alsaLib xlibsWrapper libxslt systemd libusb libftdi1 ]
  ++ (with python3Packages; [ python pyyaml ]);

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-systemdsystemunitdir=$(out)/lib/systemd/system"
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
