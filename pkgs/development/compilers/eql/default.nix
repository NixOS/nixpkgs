x@{builderDefsPackage
  , fetchgit, qt4, ecl
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
    rev = "7bd32f49c9965d8f7dc262a0f265b153b0a81ced";
    url = "git://gitorious.org/eql/eql";
    hash = "f5f34b1a76f65b707446cd9bee4d7cef3b6f9b5b5d8d16fcccb70dbf855c2adf";
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

  phaseNames = ["fixPaths" "buildEQLLib" "doQMake" "doMake" "buildLibEQL" "doDeploy"];

  fixPaths = a.fullDepEntry (''
    sed -re 's@[(]in-home "gui/.command-history"[)]@(concatenate '"'"'string (ext:getenv "HOME") "/.eql-gui-command-history")@' -i gui/gui.lisp
  '') ["minInit" "doUnpack"];

  buildEQLLib = a.fullDepEntry (''
    cd src
    ecl -shell make-eql-lib.lisp
  '') ["doUnpack" "addInputs"];

  doQMake = a.fullDepEntry (''
    qmake
  '') ["addInputs"];

  buildLibEQL = a.fullDepEntry (''
    sed -i eql.pro -e 's@#CONFIG += eql_dll@CONFIG += eql_dll@'
    qmake
    make
  '') ["doUnpack" "addInputs"];

  doDeploy = a.fullDepEntry (''
    cd ..
    ensureDir $out/bin $out/lib/eql/ $out/include $out/include/gen $out/lib
    cp -r . $out/lib/eql/build-dir
    ln -s $out/lib/eql/build-dir/eql $out/bin
    ln -s $out/lib/eql/build-dir/src/*.h $out/include
    ln -s $out/lib/eql/build-dir/src/gen/*.h $out/include/gen
    mv $out/lib/eql/build-dir/my_app/libeql*.so* $out/lib
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

