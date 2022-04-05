{ lib
, stdenv
, fetchFromGitHub
, autoconf
, gtk2
, libGL
, libGLU
, libSM
, libXinerama
, libXxf86vm
, pkg-config
, xorgproto
, compat24 ? false
, compat26 ? true
, unicode ? true
, withMesa ? lib.elem stdenv.hostPlatform.system lib.platforms.mesaPlatforms
, AGL
, Carbon
, Cocoa
, Kernel
, QuickTime
, setfile
}:

stdenv.mkDerivation rec {
  pname = "wxGTK";
  version = "2.9.5";

  src = fetchFromGitHub {
    owner = "wxWidgets";
    repo = "wxWidgets";
    rev = "v${version}";
    hash = "sha256-izefAPU4lORZxQja7/InHyElJ1++2lDloR+xPudsRNE=";
  };

  patches = [
    # https://github.com/wxWidgets/wxWidgets/issues/17942
    ./patches/0001-fix-assertion-using-hide-in-destroy.patch
  ];

  nativeBuildInputs = [
    autoconf
    pkg-config
  ];

  buildInputs = [
    gtk2
    libSM
    libXinerama
    libXxf86vm
    xorgproto
  ]
  ++ lib.optional withMesa libGLU
  ++ lib.optionals stdenv.isDarwin [
    Carbon
    Cocoa
    Kernel
    QuickTime
    setfile
  ];

  propagatedBuildInputs = lib.optional stdenv.isDarwin AGL;

  configureFlags = [
    "--disable-precomp-headers"
    "--enable-gtk2"
    (if compat24 then "--enable-compat24" else "--disable-compat24")
    (if compat26 then "--enable-compat26" else "--disable-compat26")
  ]
  ++ lib.optional unicode "--enable-unicode"
  ++ lib.optional withMesa "--with-opengl"
  ++ lib.optionals stdenv.isDarwin [ # allow building on 64-bit
    "--enable-universal-binaries"
    "--with-cocoa"
    "--with-macosx-version-min=10.7"
  ];

  SEARCH_LIB = "${libGLU.out}/lib ${libGL.out}/lib ";

  preConfigure = ''
    ./autogen.sh
    substituteInPlace configure --replace \
      'SEARCH_INCLUDE=' 'DUMMY_SEARCH_INCLUDE='
    substituteInPlace configure --replace \
      'SEARCH_LIB=' 'DUMMY_SEARCH_LIB='
    substituteInPlace configure --replace \
      /usr /no-such-path
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure --replace \
      'ac_cv_prog_SETFILE="/Developer/Tools/SetFile"' \
      'ac_cv_prog_SETFILE="${setfile}/bin/SetFile"'
    substituteInPlace configure --replace \
      "-framework System" "-lSystem"
  '';

  postInstall = ''
    pushd $out/include
    ln -s wx-*/* .
    popd
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.wxwidgets.org/";
    description = "A Cross-Platform C++ GUI Library";
    longDescription = ''
      wxWidgets gives you a single, easy-to-use API for writing GUI applications
      on multiple platforms that still utilize the native platform's controls
      and utilities. Link with the appropriate library for your platform and
      compiler, and your application will adopt the look and feel appropriate to
      that platform. On top of great GUI functionality, wxWidgets gives you:
      online help, network programming, streams, clipboard and drag and drop,
      multithreading, image loading and saving in a variety of popular formats,
      database support, HTML viewing and printing, and much more.
    '';
    license = licenses.wxWindows;
    maintainers = with maintainers; [ ];
    platforms = platforms.darwin ++ platforms.linux;
    badPlatforms = [ "x86_64-darwin" ];
  };

  passthru = {
    inherit compat24 compat26 unicode;
    gtk = gtk2;
  };
}
