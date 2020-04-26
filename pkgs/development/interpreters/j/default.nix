{ stdenv, fetchFromGitHub, readline, libedit, bc }:

let

  buildJAddonGitHub = { name, owner, rev, sha256 }: stdenv.mkDerivation { 
    name = name;
    src = fetchFromGitHub {
      owner = owner;
      repo = name;
      rev = rev;
      sha256 = sha256;
    };
    configurePhase = ''
      # set this to nonempty string to disable default cmake configure
    '';

    buildPhase = "";

    installPhase = ''
      name="${name}"
      mkdir -p $out/addons

      #eg: "convert_json" => d1="convert" d2="json"
      d1=$(echo "$name" | cut -d_ -f 1 -)
      d2=$(echo "$name" | cut -d_ -f 2 -)

      mkdir -p "$out/addons/$d1"

      cp -r $(pwd) "$out/addons/$d1/$d2"
    '';
  };

  # List of addons from: https://github.com/jsoftware/addonrepos/blob/master/repos.txt

#  #github:bilam/ide_jnet
#  ide_jnet = buildJAddonGitHub {
#    name = "ide_jnet";
#    owner = "bilam";
#    rev = "";
#    sha256 = "";
#  };
#  #github:bobtherriault/media_videolabs
#  media_videolabs = buildJAddonGitHub {
#    name = "media_videolabs";
#    owner = "bobtherriault";
#    rev = "";
#    sha256 = "";
#  };
#  #github:cdburke/convert_pjson
#  convert_pjson = buildJAddonGitHub {
#    name = "convert_pjson";
#    owner = "cdburke";
#    rev = "";
#    sha256 = "";
#  };
#  #github:cdburke/data_sqlite
#  data_sqlite = buildJAddonGitHub {
#    name = "data_sqlite";
#    owner = "cdburke";
#    rev = "";
#    sha256 = "";
#  };
#  #github:earthspot/math_cal
#  math_cal = buildJAddonGitHub {
#    name = "math_cal";
#    owner = "earthspot";
#    rev = "";
#    sha256 = "";
#  };
#  #github:earthspot/math_tabula
#  math_tabula = buildJAddonGitHub {
#    name = "math_tabula";
#    owner = "earthspot";
#    rev = "";
#    sha256 = "";
#  };
#  #github:earthspot/math_uu
#  math_uu = buildJAddonGitHub {
#    name = "math_uu";
#    owner = "earthspot";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jip/mt
#  mt = buildJAddonGitHub {
#    name = "mt";
#    owner = "jip";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/api_expat
#  api_expat = buildJAddonGitHub {
#    name = "api_expat";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/api_gles
#  api_gles = buildJAddonGitHub {
#    name = "api_gles";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/api_java
#  api_java = buildJAddonGitHub {
#    name = "api_java";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/api_lapacke
#  api_lapacke = buildJAddonGitHub {
#    name = "api_lapacke";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/api_jc
#  api_jc = buildJAddonGitHub {
#    name = "api_jc";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/api_jni
#  api_jni = buildJAddonGitHub {
#    name = "api_jni";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/api_ncurses
#  api_ncurses = buildJAddonGitHub {
#    name = "api_ncurses";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/api_python3
#  api_python3 = buildJAddonGitHub {
#    name = "api_python3";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/arc_ziptrees
#  arc_ziptrees = buildJAddonGitHub {
#    name = "arc_ziptrees";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/arc_zlib
#  arc_zlib = buildJAddonGitHub {
#    name = "arc_zlib";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/convert_jiconv
#  convert_jiconv = buildJAddonGitHub {
#    name = "convert_jiconv";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
 #github:jsoftware/convert_json
 convert_json = buildJAddonGitHub {
   name = "convert_json";
   owner = "jsoftware";
   rev = "7fdff1f8898b958c14c1035f6b42e494bd98fd0d";
   sha256 = "1896hjd43lzmrrags4srgm73r0lf36b89x1z2vdikdwwrksrr9ms";
 };
#  #github:jsoftware/convert_misc
#  convert_misc = buildJAddonGitHub {
#    name = "convert_misc";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/data_ddmysql
#  data_ddmysql = buildJAddonGitHub {
#    name = "data_ddmysql";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/data_ddsqlite
#  data_ddsqlite = buildJAddonGitHub {
#    name = "data_ddsqlite";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/data_jd
#  data_jd = buildJAddonGitHub {
#    name = "data_jd";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/data_jfiles
#  data_jfiles = buildJAddonGitHub {
#    name = "data_jfiles";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/data_jmf
#  data_jmf = buildJAddonGitHub {
#    name = "data_jmf";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/data_odbc
#  data_odbc = buildJAddonGitHub {
#    name = "data_odbc";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/data_sqltable
#  data_sqltable = buildJAddonGitHub {
#    name = "data_sqltable";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/debug_dissect
#  debug_dissect = buildJAddonGitHub {
#    name = "debug_dissect";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/debug_jig
#  debug_jig = buildJAddonGitHub {
#    name = "debug_jig";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/debug_lint
#  debug_lint = buildJAddonGitHub {
#    name = "debug_lint";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/debug_tte
#  debug_tte = buildJAddonGitHub {
#    name = "debug_tte";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/demos_coins
#  demos_coins = buildJAddonGitHub {
#    name = "demos_coins";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/demos_isigraph
#  demos_isigraph = buildJAddonGitHub {
#    name = "demos_isigraph";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/demos_publish
#  demos_publish = buildJAddonGitHub {
#    name = "demos_publish";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/demos_qtdemo
#  demos_qtdemo = buildJAddonGitHub {
#    name = "demos_qtdemo";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/demos_wd
#  demos_wd = buildJAddonGitHub {
#    name = "demos_wd";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/demos_wdplot
#  demos_wdplot = buildJAddonGitHub {
#    name = "demos_wdplot";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/dev_fold
#  dev_fold = buildJAddonGitHub {
#    name = "dev_fold";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/docs_help
#  docs_help = buildJAddonGitHub {
#    name = "docs_help";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/docs_joxygen
#  docs_joxygen = buildJAddonGitHub {
#    name = "docs_joxygen";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/finance_actuarial
#  finance_actuarial = buildJAddonGitHub {
#    name = "finance_actuarial";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/finance_interest
#  finance_interest = buildJAddonGitHub {
#    name = "finance_interest";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/format_datefmt
#  format_datefmt = buildJAddonGitHub {
#    name = "format_datefmt";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/format_printf
#  format_printf = buildJAddonGitHub {
#    name = "format_printf";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/format_publish
#  format_publish = buildJAddonGitHub {
#    name = "format_publish";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/format_sbox
#  format_sbox = buildJAddonGitHub {
#    name = "format_sbox";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/format_zulu
#  format_zulu = buildJAddonGitHub {
#    name = "format_zulu";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/format_zulu-bare
#  format_zulu-bare = buildJAddonGitHub {
#    name = "format_zulu-bare";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/format_zulu-lite
#  format_zulu-lite = buildJAddonGitHub {
#    name = "format_zulu-lite";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/games_2048
#  games_2048 = buildJAddonGitHub {
#    name = "games_2048";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/games_minesweeper
#  games_minesweeper = buildJAddonGitHub {
#    name = "games_minesweeper";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/games_nurikabe
#  games_nurikabe = buildJAddonGitHub {
#    name = "games_nurikabe";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/games_pousse
#  games_pousse = buildJAddonGitHub {
#    name = "games_pousse";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/games_solitaire
#  games_solitaire = buildJAddonGitHub {
#    name = "games_solitaire";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/general_dirtrees
#  general_dirtrees = buildJAddonGitHub {
#    name = "general_dirtrees";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/general_dirutils
 general_dirutils = buildJAddonGitHub {
   name = "general_dirutils";
   owner = "jsoftware";
   rev = "8221d58878d2926dde42a7a1330ae5e994410c53";
   sha256 = "12jl7mi6wm5s3116gkv8j1x04dzxfhws7824jhpcdv97siafymdy";
 };
#  #github:jsoftware/general_inifiles
#  general_inifiles = buildJAddonGitHub {
#    name = "general_inifiles";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/general_jod
#  general_jod = buildJAddonGitHub {
#    name = "general_jod";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/general_joddocument
#  general_joddocument = buildJAddonGitHub {
#    name = "general_joddocument";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/general_jodsource
#  general_jodsource = buildJAddonGitHub {
#    name = "general_jodsource";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/general_misc
#  general_misc = buildJAddonGitHub {
#    name = "general_misc";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/general_primitives
#  general_primitives = buildJAddonGitHub {
#    name = "general_primitives";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/general_unittest
#  general_unittest = buildJAddonGitHub {
#    name = "general_unittest";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/graphics_afm
#  graphics_afm = buildJAddonGitHub {
#    name = "graphics_afm";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/graphics_bmp
#  graphics_bmp = buildJAddonGitHub {
#    name = "graphics_bmp";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/graphics_cairo
#  graphics_cairo = buildJAddonGitHub {
#    name = "graphics_cairo";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/graphics_color
#  graphics_color = buildJAddonGitHub {
#    name = "graphics_color";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/graphics_d3
#  graphics_d3 = buildJAddonGitHub {
#    name = "graphics_d3";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/graphics_freeglut
#  graphics_freeglut = buildJAddonGitHub {
#    name = "graphics_freeglut";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/graphics_fvj4
#  graphics_fvj4 = buildJAddonGitHub {
#    name = "graphics_fvj4";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/graphics_gnuplot
#  graphics_gnuplot = buildJAddonGitHub {
#    name = "graphics_gnuplot";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/graphics_graph
#  graphics_graph = buildJAddonGitHub {
#    name = "graphics_graph";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/graphics_graphviz
#  graphics_graphviz = buildJAddonGitHub {
#    name = "graphics_graphviz";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/graphics_jpeg
#  graphics_jpeg = buildJAddonGitHub {
#    name = "graphics_jpeg";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/graphics_pdfdraw
#  graphics_pdfdraw = buildJAddonGitHub {
#    name = "graphics_pdfdraw";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/graphics_plot
#  graphics_plot = buildJAddonGitHub {
#    name = "graphics_plot";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/graphics_png
#  graphics_png = buildJAddonGitHub {
#    name = "graphics_png";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/graphics_pplatimg
#  graphics_pplatimg = buildJAddonGitHub {
#    name = "graphics_pplatimg";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/graphics_print
#  graphics_print = buildJAddonGitHub {
#    name = "graphics_print";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/graphics_treemap
#  graphics_treemap = buildJAddonGitHub {
#    name = "graphics_treemap";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/graphics_viewmat
#  graphics_viewmat = buildJAddonGitHub {
#    name = "graphics_viewmat";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/gui_cobrowser
#  gui_cobrowser = buildJAddonGitHub {
#    name = "gui_cobrowser";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/ide_ja
#  ide_ja = buildJAddonGitHub {
#    name = "ide_ja";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/ide_jhs
#  ide_jhs = buildJAddonGitHub {
#    name = "ide_jhs";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/ide_qt
#  ide_qt = buildJAddonGitHub {
#    name = "ide_qt";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/labs_labs
#  labs_labs = buildJAddonGitHub {
#    name = "labs_labs";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/math_calculus
#  math_calculus = buildJAddonGitHub {
#    name = "math_calculus";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/math_deoptim
#  math_deoptim = buildJAddonGitHub {
#    name = "math_deoptim";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/math_eigenpic
#  math_eigenpic = buildJAddonGitHub {
#    name = "math_eigenpic";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/math_fftw
#  math_fftw = buildJAddonGitHub {
#    name = "math_fftw";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/math_flann
#  math_flann = buildJAddonGitHub {
#    name = "math_flann";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/math_lapack
#  math_lapack = buildJAddonGitHub {
#    name = "math_lapack";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/math_lapack2
#  math_lapack2 = buildJAddonGitHub {
#    name = "math_lapack2";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/math_lbfgs
#  math_lbfgs = buildJAddonGitHub {
#    name = "math_lbfgs";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/math_misc
#  math_misc = buildJAddonGitHub {
#    name = "math_misc";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/media_imagekit
#  media_imagekit = buildJAddonGitHub {
#    name = "media_imagekit";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/media_wav
#  media_wav = buildJAddonGitHub {
#    name = "media_wav";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/misc_classroom
#  misc_classroom = buildJAddonGitHub {
#    name = "misc_classroom";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/misc_miscutils
#  misc_miscutils = buildJAddonGitHub {
#    name = "misc_miscutils";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/net_clientserver
#  net_clientserver = buildJAddonGitHub {
#    name = "net_clientserver";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/net_jcs
#  net_jcs = buildJAddonGitHub {
#    name = "net_jcs";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/net_websocket
#  net_websocket = buildJAddonGitHub {
#    name = "net_websocket";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/net_zmq
#  net_zmq = buildJAddonGitHub {
#    name = "net_zmq";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/profiles_profiles
#  profiles_profiles = buildJAddonGitHub {
#    name = "profiles_profiles";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/sockets_socklib
#  sockets_socklib = buildJAddonGitHub {
#    name = "sockets_socklib";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/sockets_sockutils
#  sockets_sockutils = buildJAddonGitHub {
#    name = "sockets_sockutils";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/stats_base
#  stats_base = buildJAddonGitHub {
#    name = "stats_base";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/stats_distribs
#  stats_distribs = buildJAddonGitHub {
#    name = "stats_distribs";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/stats_jserver4r
#  stats_jserver4r = buildJAddonGitHub {
#    name = "stats_jserver4r";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/stats_r
#  stats_r = buildJAddonGitHub {
#    name = "stats_r";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/stats_rlibrary
#  stats_rlibrary = buildJAddonGitHub {
#    name = "stats_rlibrary";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/tables_csv
#  tables_csv = buildJAddonGitHub {
#    name = "tables_csv";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/tables_dsv
#  tables_dsv = buildJAddonGitHub {
#    name = "tables_dsv";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/tables_excel
#  tables_excel = buildJAddonGitHub {
#    name = "tables_excel";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/tables_tara
#  tables_tara = buildJAddonGitHub {
#    name = "tables_tara";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/tables_taraxml
#  tables_taraxml = buildJAddonGitHub {
#    name = "tables_taraxml";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/tables_wdooo
#  tables_wdooo = buildJAddonGitHub {
#    name = "tables_wdooo";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/types_datetime
#  types_datetime = buildJAddonGitHub {
#    name = "types_datetime";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };
#  #github:jsoftware/web_gethttp
#  web_gethttp = buildJAddonGitHub {
#    name = "web_gethttp";
#    owner = "jsoftware";
#    rev = "";
#    sha256 = "";
#  };

in stdenv.mkDerivation rec {
  pname = "j";
  version = "901";
  jtype = "release-e";
  src = fetchFromGitHub {
    owner = "jsoftware";
    repo = "jsource";
    rev = "j${version}-${jtype}";
    sha256 = "13ky37rrl6mc66fckrdnrw64gmvq1qlv6skzd513lab4d0wigshw";
    name = "jsource";
  };

  buildInputs = [ readline libedit bc ];
  bits = if stdenv.is64bit then "64" else "32";
  platform = if (stdenv.isAarch32 || stdenv.isAarch64) then
    "raspberry"
  else if stdenv.isLinux then
    "linux"
  else if stdenv.isDarwin then
    "darwin"
  else
    "unknown";

  doCheck = true;

  buildPhase = ''
    export SOURCE_DIR=$(pwd)
    export HOME=$TMPDIR
    export JLIB=$SOURCE_DIR/jlibrary

    echo $OUT_DIR

    cd make2

    patchShebangs .
    sed -i $JLIB/bin/profile.ijs -e "s@'/usr/share/j/.*'@'$out/share/j'@;"

    ./build_all.sh

    cp $SOURCE_DIR/bin/${platform}/j${bits}*/* "$JLIB/bin"
  '';

  checkPhase = ''

    echo 'i. 5' | $JLIB/bin/jconsole | fgrep "0 1 2 3 4"

    # Now run the real tests
    cd $SOURCE_DIR/test
    for f in *.ijs
    do
      echo $f
      $JLIB/bin/jconsole < $f > /dev/null || echo FAIL && echo PASS
    done
  '';

  installPhase = ''
    mkdir -p "$out"

    mkdir -p "$out/share/j"
    cp -r $JLIB/{addons,system} "$out/share/j"
    cp -r $JLIB/bin "$out"

    # install addons
    cp -r ${convert_json}/addons "$out/share/j"
    cp -r ${general_dirutils}/addons "$out/share/j"
  '';

  meta = with stdenv.lib; {
    description = "J programming language, an ASCII-based APL successor";
    maintainers = with maintainers; [ raskin synthetica ];
    platforms = with platforms; linux ++ darwin;
    license = licenses.gpl3Plus;
    homepage = "http://jsoftware.com/";
  };
}
