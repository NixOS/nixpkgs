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
  sourceInfo = {
    method = "fetchgit";
    rev = "370b7968fd73d5babc81e35913a37111a788487f";
    url = "git://gitorious.org/eql/eql";
    hash = "2370e111d86330d178f3ec95e8fed13607e51fed8859c6e95840df2a35381636";
    version = rev;
    name = "eql-git-${version}";
  };
in
rec {
  src = a.fetchgit {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
    rev = sourceInfo.rev;
  } + "/";

  inherit (sourceInfo) name version;
  inherit buildInputs;

  phaseNames = ["fixPaths" "buildEQLLib" "doQMake" "doMake" "doDeploy"];

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

  doDeploy = a.fullDepEntry (''
    cd ..
    ensureDir $out/bin $out/lib/eql/
    cp -r . $out/lib/eql/build-dir
    ln -s $out/lib/eql/build-dir/eql $out/bin
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
  };
}) x

