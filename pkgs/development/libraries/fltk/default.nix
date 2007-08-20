args:
with args;
with args.lib; 
let 
  co = chooseOptionsByFlags {
    inherit args;
    flagDescr = 
      { mandatory = { cfgOption = " --prefix=\$out"; 
                      buildInputs=["libX11" "libXext"]; 
                      blocks = ["cygwin" "quartz"]; } # cgywin quartz and much more not yet tested
      ; cygwin = { cfgOption = "--enable-cygwin"; } #         use the CygWin libraries default=no
      ; debug = { cfgOption = "--enable-debug"; } #          turn on debugging default=no
      ; gl = { cfgOption = "--enable-gl"; buildInputs = [ "mesa" "mesa-heaaders"]; } #             turn on OpenGL support default=yes
      ; shared = { cfgOption = "--enable-shared"; } #         turn on shared libraries default=no
      ; threads = { cfgOption = "--enable-threads"; } #        enable multi-threading support
      ; quartz = { cfgOption = "--enable-quartz"; buildInputs = "quartz"; } # don't konw yet what quartz is #         use Quartz instead of Quickdraw (default=no)
      ; largefile = { cfgOption = "--disable-largefile"; } #     omit support for large files
      ; useNixLibs = { implies = [ "nixjpeg" "nixpng" "nixzlib" ]; } # use nix libraries only
      ; nixjpeg = { cfgOption = "--disable-localjpeg"; buildInputs = "libjpeg"; } #      use local JPEG library, default=auto
      ; nixzlib = { cfgOption = "--disable-localzlib"; buildInputs = "zlib"; } #      use local ZLIB library, default=auto
      ; nixpng = { cfgOption = "--disable-localpng"; buildInputs = "libpng"; } #       use local PNG library, default=auto
      ; xinerama = { cfgOption = "--enable-xinerama"; buildInputs = "xinerama"; } #       turn on Xinerama support default=no
      ; xft = { cfgOption = "--enable-xft"; buildInputs="xft"; } #            turn on Xft support default=no
      ; xdbe = { cfgOption = "--enable-xdbe"; } #           turn on Xdbe support default=no
      ;};
    };
in
args.stdenv.mkDerivation {
  inherit (co) /* flags */ buildInputs;
  name = "fltk-2.0.x-r5940";

  configurePhase = "./configure " + co.configureFlags;

  src = fetchurl {
    url = http://mirror.switch.ch/mirror/gentoo/distfiles/fltk-1.1.7-source.tar.bz2;
    sha256 = "855a97e35da823f205253b865758715872cd2c7720e4dcf134a3b6dc18bfb96a";
  };

  meta = { 
      description = "a C++ cross platform lightweight gui library binding";
      homepage = http://www.fltk.org;
  };
  
  dummy=2;
}
