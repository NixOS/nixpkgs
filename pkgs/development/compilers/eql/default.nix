x@{builderDefsPackage
  , fetchgit, qt4, ecl, xorgserver
  , xkbcomp, xkeyboard_config
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    ["fetchgit"];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    method = "fetchgit";
    rev = "14f62c94f952104d27d920ea662c8a61b370abe8";
    url = "git://gitorious.org/eql/eql";
    hash = "1ca31f0ad8cbc45d2fdf7b1e4059b1e612523c043f4688d7147c7e16fa5ba9ca";
    version = rev;
    name = "eql-git-${version}";
  };
in
rec {
  srcDrv = a.fetchgit {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
    rev = sourceInfo.rev;
  };
  src = srcDrv + "/";

  inherit (sourceInfo) name version;
  inherit buildInputs;

  phaseNames = ["setVars" "fixPaths" "firstMetaTypeId" "buildEQLLib" "doQMake" "doMake" "doDeploy"];

  setVars = a.fullDepEntry (''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -fPIC"
  '') [];

  fixPaths = a.fullDepEntry (''
    sed -re 's@[(]in-home "gui/.command-history"[)]@(concatenate '"'"'string (ext:getenv "HOME") "/.eql-gui-command-history")@' -i gui/gui.lisp
  '') ["minInit" "doUnpack"];

  firstMetaTypeId = a.fullDepEntry (''
    cd src 
    qmake first_metatype_id.pro
    make
    TMP=.
    TMPDIR=.
    XKB_BINDIR="${xkbcomp}/bin" Xvfb -once -reset -terminate :2 -xkbdir ${xkeyboard_config}/etc/X11/xkb &
    sleep 10;
    DISPLAY=:2 ./first_metatype_id
  '') ["doUnpack" "addInputs"];

  buildEQLLib = a.fullDepEntry (''
    ecl -shell make-eql-lib.lisp
    qmake eql_lib.pro
    make
  '') ["doUnpack" "addInputs" "firstMetaTypeId"];

  doQMake = a.fullDepEntry (''
    qmake eql_exe.pro
    make
  '') ["addInputs" "firstMetaTypeId" "buildEQLLib"];

  doDeploy = a.fullDepEntry (''
    cd ..
    mkdir -p $out/bin $out/lib/eql/ $out/include $out/include/gen $out/lib
    cp -r . $out/lib/eql/build-dir
    ln -s $out/lib/eql/build-dir/eql $out/bin
    ln -s $out/lib/eql/build-dir/src/*.h $out/include
    ln -s $out/lib/eql/build-dir/src/gen/*.h $out/include/gen
    ln -s $out/lib/eql/build-dir/libeql*.so* $out/lib
  '') ["minInit" "defEnsureDir"];

  meta = {
    description = "Embedded Qt Lisp (ECL+Qt)";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://password-taxi.at/EQL";
      method = "fetchgit";
      rev = "370b7968fd73d5babc81e35913a37111a788487f";
      url = "git://gitorious.org/eql/eql";
      hash = "2370e111d86330d178f3ec95e8fed13607e51fed8859c6e95840df2a35381636";
    };
    inherit srcDrv;
  };
}) x

