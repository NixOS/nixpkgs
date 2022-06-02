{ stdenv
, lib
, fetchurl
, pkg-config
, autoreconfHook
, glib
, libusb1
}:

stdenv.mkDerivation rec {
  pname = "libticables2";
  version = "1.3.5";
  src = fetchurl {
    url = "mirror://sourceforge/tilp/${pname}-${version}.tar.bz2";
    sha256 = "08j5di0cgix9vcpdv7b8xhxdjkk9zz7fqfnv3l4apk3jdr8vcvqc";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libusb1
    glib
  ];

  configureFlags = [
    "--enable-libusb10"
  ];

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d
    cat > $out/etc/udev/rules.d/69-libsane.rules << EOF
      ACTION!="add", GOTO="libticables_end"

      # serial device (assume TI calculator)
      KERNEL=="ttyS[0-3]", ENV{ID_PDA}="1"
      # parallel device (assume TI calculator)
      SUBSYSTEM=="ppdev", ENV{ID_PDA}="1"
      # SilverLink
      SUBSYSTEM=="usb", ATTR{idVendor}=="0451", ATTR{idProduct}=="e001", ENV{ID_PDA}="1"
      # TI-84+ DirectLink
      SUBSYSTEM=="usb", ATTR{idVendor}=="0451", ATTR{idProduct}=="e003", ENV{ID_PDA}="1"
      # TI-89 Titanium DirectLink
      SUBSYSTEM=="usb", ATTR{idVendor}=="0451", ATTR{idProduct}=="e004", ENV{ID_PDA}="1"
      # TI-84+ SE DirectLink
      SUBSYSTEM=="usb", ATTR{idVendor}=="0451", ATTR{idProduct}=="e008", ENV{ID_PDA}="1"
      # TI-Nspire DirectLink
      SUBSYSTEM=="usb", ATTR{idVendor}=="0451", ATTR{idProduct}=="e012", ENV{ID_PDA}="1"

      LABEL="libticables_end"
    EOF
  '';

  meta = with lib; {
    changelog = "http://lpg.ticalc.org/prj_tilp/news.html";
    description = "This library is part of the TiLP framework";
    homepage = "http://lpg.ticalc.org/prj_tilp/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ siraben luc65r ];
    platforms = with platforms; linux ++ darwin;
  };
}
