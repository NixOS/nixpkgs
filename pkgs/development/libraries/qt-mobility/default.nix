{ stdenv, fetchurl, qt4, libX11, coreutils, bluez, perl }:
# possible additional dependencies: pulseaudio udev networkmanager immerson qmf

stdenv.mkDerivation rec {
  version = "1.2.0";
  name = "qt-mobility-${version}";
  download = "qt-mobility-opensource-src-${version}";
  src = fetchurl {
    url =  "http://get.qt.nokia.com/qt/add-ons/${download}.tar.gz";
    sha256 = "ee3c88975e04139ac9589f76d4be646d44fcbc4c8c1cf2db621abc154cf0ba44";
  };

  NIX_CFLAGS_COMPILE="-fpermissive";

  configurePhase = ''
    ./configure -prefix $out
  '';

  # we need to prevent the 'make install' to want to write to ${qt4}!
  preBuild = ''
    for i in connectivity contacts feedback gallery location multimedia organizer publishsubscribe sensors serviceframework systeminfo; do
      substituteInPlace plugins/declarative/$i/Makefile --replace "${qt4}/lib/qt4/imports/" "$out/lib/qt4/imports/"
    done
  '';

  patchPhase = ''
    # required to make the configure script work
    substituteInPlace configure --replace "/bin/pwd" "${coreutils}/bin/pwd"

    # required to make /include generator work
    substituteInPlace bin/syncheaders --replace "/usr/bin/perl" "${perl}/bin/perl"

    # required to make the -prefix variable parsing work
    substituteInPlace bin/pathhelper --replace "/usr/bin/perl" "${perl}/bin/perl"
  '';

  buildInputs = [ qt4 libX11 bluez perl];

  meta = {
    description = "Qt Mobility";
    homepage = http://qt.nokia.com/products/qt-addons/mobility;
    maintainers = with stdenv.lib.maintainers; [qknight];
  };
}


