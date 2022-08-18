{ lib
, stdenv
, fetchFromGitHub
, perl
, swig
, gd
, ncurses
, python3
, libxml2
, tcl
, libusb-compat-0_1
, pkg-config
, autoconf
, automake
, boost
, libtool
, perlPackages
, pythonBindings ? true
, tclBindings ? true
, perlBindings ? true
}:

stdenv.mkDerivation rec {
  pname = "jtdxhamlib";
  version = "159";

  src = fetchFromGitHub {
    owner = "jtdx-project";
    repo = pname;
    rev = version;
    sha256 = "sha256-20nrI+XICdYGgsydFP7DM/zMMcOMBCHz8JZUM10IOmc=";
  };

  nativeBuildInputs = [
    swig
    pkg-config
    libtool
    autoconf
    automake
  ];

  buildInputs = [
    gd
    libxml2
    libusb-compat-0_1
    boost
  ] ++ lib.optionals pythonBindings [ python3 ncurses ]
    ++ lib.optionals tclBindings [ tcl ]
    ++ lib.optionals perlBindings [ perl perlPackages.ExtUtilsMakeMaker ];

  preConfigure = ''
    ./bootstrap
  '';

  configureFlags = lib.optionals perlBindings [ "--with-perl-binding" ]
    ++ lib.optionals tclBindings [ "--with-tcl-binding" "--with-tcl=${tcl}/lib/" ]
    ++ lib.optionals pythonBindings [ "--with-python-binding" ]
    ++ [ "--disable-winradio" "--without-cxx-binding" ];

  installPhase = ''
    make install-strip
  '';

  meta = with lib; {
    description = "Ham radio control library modified for JTDX";
    longDescription = ''
    This is a fork of Hamlib modified for JTDX.

    Hamlib provides a standardized programming interface that applications
    can use to send the appropriate commands to a radio.

    Also included in the package is a simple radio control program 'rigctl',
    which lets one control a radio transceiver or receiver, either from
    command line interface or in a text-oriented interactive interface.
    '';
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    homepage = "https://github.com/jtdx-project/jtdxhamlib";
    maintainers = with maintainers; [ CesarGallego nilp0inter ];
    platforms = with platforms; unix;
  };
}
