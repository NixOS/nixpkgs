{ lib
, stdenv
, fetchgit
, autoreconfHook
, perl
, swig
, gd
, ncurses
, python3
, libxml2
, tcl
, libusb1
, pkg-config
, boost
, libtool
, perlPackages
, pythonBindings ? true
, tclBindings ? true
, perlBindings ? stdenv.buildPlatform == stdenv.hostPlatform
, buildPackages
}:

let
  version = "4.3.1";
in stdenv.mkDerivation {
  pname = "hamlib";
  version = "${version}-wsjtx";

  src = fetchgit {
    url = "git://git.code.sf.net/u/bsomervi/hamlib";
    rev = version;
    hash = "sha256-aXQjB49GBVz9rY67VXHLMmLM1l4ZR53By4XroenSvak=";
  };

  strictDeps = true;
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    autoreconfHook
    swig
    pkg-config
    libtool
  ] ++ lib.optionals pythonBindings [ python3 ]
    ++ lib.optionals tclBindings [ tcl ]
    ++ lib.optionals perlBindings [ perl ];

  buildInputs = [
    gd
    libxml2
    libusb1
    boost
  ] ++ lib.optionals pythonBindings [ python3 ncurses ]
    ++ lib.optionals tclBindings [ tcl ];


  configureFlags = [
    "CC_FOR_BUILD=${stdenv.cc.targetPrefix}cc"
  ] ++ lib.optionals perlBindings [ "--with-perl-binding" ]
    ++ lib.optionals tclBindings [ "--with-tcl-binding" "--with-tcl=${tcl}/lib/" ]
    ++ lib.optionals pythonBindings [ "--with-python-binding" ];

  meta = with lib; {
    description = "WSJT-X fork of the runtime library to control radio transceivers and receivers";
    longDescription = ''
    Hamlib provides a standardized programming interface that applications
    can use to send the appropriate commands to a radio.

    Also included in the package is a simple radio control program 'rigctl',
    which lets one control a radio transceiver or receiver, either from
    command line interface or in a text-oriented interactive interface.

    This package is the fork used by WSJT-X and related applications.
    '';
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    homepage = "https://hamlib.sourceforge.net";
    maintainers = with maintainers; [ melling ];
    platforms = with platforms; unix;
  };
}
