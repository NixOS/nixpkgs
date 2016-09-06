{ stdenv, fetchFromGitHub, pkgconfig, gtk, libXinerama, libSM, libXxf86vm, xf86vidmodeproto
, gstreamer, gst_plugins_base, GConf
, setfile ? null, Cocoa ? null, QuickTime ? null, Kernel ? null, QTKit ? null, rez ? null, derez ? null
, withMesa ? true, mesa ? null, unicode ? true
, compat28 ? false, compat30 ? false
, autoconf
}:

assert withMesa -> mesa != null;

with stdenv.lib;

let
  version = "3.1.0";
in
stdenv.mkDerivation {
  name = "wxwidgets-${version}";

  src = fetchFromGitHub {
    owner = "wxWidgets";
    repo = "wxWidgets";
    rev = "v${version}";
    sha256 = "14kl1rsngm70v3mbyv1mal15iz2b18k97avjx8jn7s81znha1c7f";
  };

  buildInputs =
    [ gtk libXinerama libSM libXxf86vm xf86vidmodeproto gstreamer
      gst_plugins_base GConf ]
    ++ optional withMesa mesa
    ++ optionals stdenv.isDarwin [ setfile rez derez ];

  propagatedBuildInputs = optionals stdenv.isDarwin [ Cocoa QuickTime Kernel QTKit ];

  nativeBuildInputs = [ pkgconfig autoconf ];

  postPatch = if stdenv.isDarwin then ''
    substituteInPlace configure.in --replace "-framework System" -lSystem
    substituteInPlace build/aclocal/bakefile.m4 --replace /Developer/Tools/SetFile ${setfile}/bin/SetFile
  '' else "";

  preConfigure = "autoconf -B build/autoconf_prepend-include";

  configureFlags = [
    "--disable-precomp-headers"
    "--enable-compat28=${if compat28 then "yes" else "no"}"
    "--enable-compat30=${if compat30 then "yes" else "no"}"
    "--with-opengl=${if withMesa then "yes" else "no"}"
  ]
    ++ optional unicode "--enable-unicode"
    ++ optional stdenv.isDarwin "--with-cocoa";

  SEARCH_LIB = optionalString withMesa "${mesa}/lib";

  patches = [ ./darwin.patch ];

  passthru = {inherit gtk compat30 compat28 unicode;};

  checkPhase = ''
    ./wx-config --libs
  '';

  doCheck = true;

  enableParallelBuilding = true;
  
  meta = {
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ matthewbauer ];
    homepage = "https://www.wxwidgets.org/";
    description = "wxWidgets is a C++ library that lets developers create applications for Windows, Mac OS X, Linux and other platforms with a single code base.";
    longDescription = "wxWidgets gives you a single, easy-to-use API for writing GUI applications on multiple platforms that still utilize the native platform's controls and utilities. Link with the appropriate library for your platform and compiler, and your application will adopt the look and feel appropriate to that platform. On top of great GUI functionality, wxWidgets gives you: online help, network programming, streams, clipboard and drag and drop, multithreading, image loading and saving in a variety of popular formats, database support, HTML viewing and printing, and much more.";
    license = stdenv.lib.licenses.wxWindows31;
  };
}
