{ lib, stdenv, fetchFromGitHub, qt4, libX11, coreutils, bluez, perl }:
# possible additional dependencies: pulseaudio udev networkmanager immerson qmf

stdenv.mkDerivation rec {
  version = "1.2.0";
  pname = "qt-mobility";
  src = fetchFromGitHub {
    owner = "qtproject";
    repo = "qt-mobility";
    rev = "v${version}";
    sha256 = "14713pbscysd6d0b9rgm7gg145jzwvgdn22778pf2v13qzvfmy1i";
  };

  env.NIX_CFLAGS_COMPILE = "-fpermissive";

  configurePhase = ''
    ./configure -prefix $out
  '';

  # we need to prevent the 'make install' to want to write to ${qt4}!
  # according to thiago#qt@freenode these are used for the QML engine
  preBuild = ''
    for i in connectivity contacts feedback gallery location multimedia organizer publishsubscribe sensors serviceframework systeminfo; do
      substituteInPlace plugins/declarative/$i/Makefile --replace "${qt4}/lib/qt4/imports/" "$out/lib/qt4/imports/"
    done
  '';

  # Features files (*.prf) are not installed on nixos
  # https://bugreports.qt-project.org/browse/QTMOBILITY-1085
  #  - features/mobility.prf (/tmp/nix-build-9kh12nhf9cyplfwiws96gz414v6wgl67-qt-mobility-1.2.0.drv-0/qt-mobility-opensource-src-1.2.0)

  patchPhase = ''
    # required to make the configure script work
    substituteInPlace configure --replace "/bin/pwd" "${coreutils}/bin/pwd"

    # required to make /include generator work
    substituteInPlace bin/syncheaders --replace "/usr/bin/perl" "${perl}/bin/perl"

    # required to make the -prefix variable parsing work
    substituteInPlace bin/pathhelper --replace "/usr/bin/perl" "${perl}/bin/perl"
  '';

  buildInputs = [ qt4 libX11 bluez perl ];

  meta = with lib; {
    description = "Qt Mobility";
    homepage = "http://qt.nokia.com/products/qt-addons/mobility";
    maintainers = [ maintainers.qknight ];
    platforms = platforms.linux;
    license = with licenses; [ bsd3 fdl13Plus gpl3Plus lgpl21Plus ];
  };
}


