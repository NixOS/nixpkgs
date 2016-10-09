{ stdenv, fetchurl, pkgconfig, coreutils
, libjpeg, libpng, libmng, zlib, libuuid, which
, x11, xextproto, libX11, xlibsWrapper
, threadSupport ? true
, cupsSupport ? true, cups ? null
, sqliteSupport ? true, sqlite ? null
, mysqlSupport ? true, mysql ? null
, postgresqlSupport ? true, postgresql ? null
, odbcSupport ? true, unixODBC ? null
, openglSupport ? true , mesa ? null, libXmu ? null
, xftSupport ? true, libXft ? null
, xrenderSupport ? true , libXrender ? null
, xrandrSupport ? true, libXrandr ? null, randrproto ? null
, xcursorSupport ? true, libXcursor ? null
, xineramaSupport ? true, libXinerama ? null
, xextSupport ? true, libXext ? null
, smSupport ? true, libSM ? null
}:

assert cupsSupport -> cups != null;
assert sqliteSupport -> sqlite != null;
assert mysqlSupport -> mysql != null;
assert postgresqlSupport -> postgresql != null;
assert odbcSupport -> unixODBC != null;
assert openglSupport -> mesa != null && libXmu != null;

assert xftSupport -> libXft != null;
assert xrenderSupport -> xftSupport && libXrender != null;
assert xrandrSupport -> libXrandr != null && randrproto != null;
assert xcursorSupport -> libXcursor != null;
assert xineramaSupport -> libXinerama != null;
assert xextSupport -> libXext != null;
assert smSupport -> libSM != null;

stdenv.mkDerivation rec {

  name = "tqt3-"+ (toString(if threadSupport then "thread" else "nothread"))+ "-${version}";
  version = "${majorVer}.${minorVer}";
  majorVer = "R14";
  minorVer = "0.3";
  srcName = "tqt3-${version}";

  src = fetchurl {
    url = "mirror://tde/${version}/dependencies/${srcName}.tar.bz2";
    sha256 = "04sm6752cmhc0jq9lcl9rv3d282mc8nqkda063160gn6jklby51x";
  };

  buildInputs = [ pkgconfig which libuuid coreutils ];
  propagatedBuildInputs = [ libpng libmng libjpeg zlib x11
    xlibsWrapper libX11 xextproto libXft libXrender ];

  patches = [
    # Resetting /bin/pwd to pwd
    ./0001-tqt-configure-pwd.diff
    # randr.h and xrandr.h aren't in the same place,
    # so they need to be searched independently
    ./0002-tqt-xrandr-test.diff ];

  # tqt3 configure script doesn't use double-dash convention  
  dontAddPrefix = true;
  setupHook = ./setup-hook.sh;
  configureFlags = ''
    -v
    -qt-gif
    -system-zlib -system-libpng -system-libjpeg -system-libmng
    -I${xextproto.out}/include
    -L${libX11.out}/lib -I${libX11.dev}/include -lX11
    ${if threadSupport then "-thread" else "-no-thread"}
    ${if openglSupport
      then "-dlopen-opengl
       -L${mesa}/lib -I${mesa}/include
       -L${libXmu.out}/lib -I${libXmu.dev}/include"
      else ""}
    ${if xrenderSupport
      then "-xrender -L${libXrender.out}/lib -I${libXrender.dev}/include"
      else "-no-xrender"}
    ${if xrandrSupport
      then "-xrandr -L${libXrandr.out}/lib -I${libXrandr.dev}/include
      -I${randrproto}/include"
      else "-no-xrandr"}
    ${if xineramaSupport
      then "-xinerama -L${libXinerama.out}/lib -I${libXinerama.dev}/include"
      else "-no-xinerama"}
    ${if xcursorSupport
      then "-L${libXcursor.out}/lib -I${libXcursor.dev}/include"
      else ""}
    ${if xftSupport
      then "-xft -L${libXft.out}/lib -I${libXft.dev}/include
      -L${libXft.freetype.out}/lib -I${libXft.freetype.dev}/include
      -L${libXft.fontconfig.lib}/lib -I${libXft.fontconfig.dev}/include"
      else "-no-xft"}
    ${if xextSupport
      then "-L${libXext.out}/lib -I${libXext.dev}/include"
      else ""}
    ${if smSupport
      then "-L${libSM.out}/lib -I${libSM.dev}/include"
      else ""}
    ${if cupsSupport
      then "-L${cups.out}/lib -I${cups.dev}/include"
      else ""}
    ${if mysqlSupport
      then "-qt-sql-mysql -L${mysql.out}/lib
      -I${mysql.out}/include/mysql"
      else ""}
    ${if postgresqlSupport
     then "-qt-sql-psql -L${postgresql.lib}/lib
     -I${postgresql.out}/include -I${postgresql.out}/include/server"
     else ""}
    ${if sqliteSupport
      then "-qt-sql-sqlite -L${sqlite.out}/lib/sqlite
      -I${sqlite.dev}/include"
      else ""}
    ${if odbcSupport
      then "-qt-sql-odbc -L${unixODBC}/lib -I${unixODBC}/include"
      else ""}
  '';

  preConfigure = ''
    for i in tqt3/config.tests/unix/checkavail \
             tqt3/config.tests/*/*.test \
             tqt3/mkspecs/*/qmake.conf; do
      echo "Preprocessing $i..."
      substituteInPlace "$i" \
        --replace " /lib" " /FAILURE" \
        --replace "/usr" "/FAILURE"
    done
  '';

  # Workaround for a compilation 'error'
  hardeningDisable = [ "format" ];

  configurePhase = ''
    cd tqt3
    sh configure -prefix $out $configureFlags
    export LD_LIBRARY_PATH=$(pwd)/lib
  '';

  # Some scripts for other libraries doesn't recognize
  # tqt-mt.pc; symlinking to tqt.pc is fine, however
  postInstall = ''
    cd $out/lib/pkgconfig
    if test -f tqt-mt.pc; then
      ln -s tqt-mt.pc tqt.pc
    fi
    '';

  meta = with stdenv.lib;{
    homepage = http://www.trinitydesktop.org;
    description = "A fork of Qt3 library, tailored for TDE";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };

  passthru = { inherit mysqlSupport; };
}
# Heavily based on QT-3 expression
# TODO: multiple inputs
# Warning: autotool build, will be deprecated by cmake in the future
