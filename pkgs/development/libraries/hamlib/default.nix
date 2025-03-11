{
  lib,
  stdenv,
  fetchurl,
  perl,
  swig,
  gd,
  ncurses,
  python311,
  libxml2,
  tcl,
  libusb-compat-0_1,
  pkg-config,
  boost,
  libtool,
  pythonBindings ? true,
  tclBindings ? true,
  perlBindings ? stdenv.buildPlatform == stdenv.hostPlatform,
  buildPackages,
}:
let
  python3 = python311; # needs distutils and imp
in
stdenv.mkDerivation rec {
  pname = "hamlib";
  version = "3.3";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "10788mgrhbc57zpzakcxv5aqnr2819pcshml6fbh8zvnkja562y9";
  };

  strictDeps = true;
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs =
    [
      swig
      pkg-config
      libtool
    ]
    ++ lib.optionals pythonBindings [ python3 ]
    ++ lib.optionals tclBindings [ tcl ]
    ++ lib.optionals perlBindings [ perl ];

  buildInputs =
    [
      gd
      libxml2
      libusb-compat-0_1
      boost
    ]
    ++ lib.optionals pythonBindings [
      python3
      ncurses
    ]
    ++ lib.optionals tclBindings [ tcl ];

  configureFlags =
    [
      "CC_FOR_BUILD=${stdenv.cc.targetPrefix}cc"
    ]
    ++ lib.optionals perlBindings [ "--with-perl-binding" ]
    ++ lib.optionals tclBindings [
      "--with-tcl-binding"
      "--with-tcl=${tcl}/lib/"
    ]
    ++ lib.optionals pythonBindings [ "--with-python-binding" ];

  meta = with lib; {
    description = "Runtime library to control radio transceivers and receivers";
    longDescription = ''
      Hamlib provides a standardized programming interface that applications
      can use to send the appropriate commands to a radio.

      Also included in the package is a simple radio control program 'rigctl',
      which lets one control a radio transceiver or receiver, either from
      command line interface or in a text-oriented interactive interface.
    '';
    license = with licenses; [
      gpl2Plus
      lgpl2Plus
    ];
    homepage = "https://hamlib.sourceforge.net";
    maintainers = with maintainers; [ relrod ];
    platforms = with platforms; unix;
  };
}
