args:
( args.mkDerivationByConfiguration {
    flagConfig = {
      mandatory = { propagatedBuildInputs=["x11" "inputproto" "libXi"]; 
                    blocks = ["cygwin" "quartz"]; }; # cgywin quartz and much more not yet tested
      cygwin = { cfgOption = "--enable-cygwin"; }; #         use the CygWin libraries default=no
      debug = { cfgOption = "--enable-debug"; }; #          turn on debugging default=no
      gl = { cfgOption = "--enable-gl"; buildInputs = [ "mesa" ]; }; #             turn on OpenGL support default=yes
      shared = { cfgOption = "--enable-shared"; }; #         turn on shared libraries default=no
      threads = { cfgOption = "--enable-threads"; }; #        enable multi-threading support
      quartz = { cfgOption = "--enable-quartz"; buildInputs = "quartz"; }; # don't konw yet what quartz is #         use Quartz instead of Quickdraw (default=no)
      largefile = { cfgOption = "--disable-largefile"; }; #     omit support for large files
      useNixLibs = { implies = [ "nixjpeg" "nixpng" "nixzlib" ]; }; # use nix libraries only
      nixjpeg = { cfgOption = "--disable-localjpeg"; buildInputs = "libjpeg"; }; #      use local JPEG library, default=auto
      nixzlib = { cfgOption = "--disable-localzlib"; buildInputs = "zlib"; }; #      use local ZLIB library, default=auto
      nixpng = { cfgOption = "--disable-localpng"; buildInputs = "libpng"; }; #       use local PNG library, default=auto
      xinerama = { cfgOption = "--enable-xinerama"; buildInputs = "xinerama"; }; #       turn on Xinerama support default=no
      xft = { cfgOption = "--enable-xft"; buildInputs="xft"; }; #            turn on Xft support default=no
      xdbe = { cfgOption = "--enable-xdbe"; }; #           turn on Xdbe support default=no
    }; 

    extraAttrs = co : {
      name = "fltk-2.0.x-r6483";

    src = args.fetchurl {
      url = ftp://ftp.easysw.com/pub/fltk/snapshots/fltk-2.0.x-r6483.tar.bz2;
      sha256 = "1n8b53r5p0zb4sbvr6pj8aasls4zjwksv1sdc3r3pzb20fikp5jb";
    };

    meta = { 
        description = "a C++ cross platform lightweight gui library binding";
        homepage = http://www.fltk.org;
    };
  };
} ) args
