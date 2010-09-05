x@{builderDefsPackage
  , doxygen, pkgconfig, ptlib, srtp, libtheora, speex
  , ffmpeg, x264, cyrus_sasl, openldap, openssl, expat, unixODBC
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="opal";
    baseVersion="3.6";
    patchlevel="8";
    version="${baseVersion}.${patchlevel}";
    name="${baseName}-${version}";
    url="mirror://gnome/sources/${baseName}/${baseVersion}/${name}.tar.bz2";
    hash="0359wqmrxqajd94sw3q2dn6n6y3caggavwdcmzyn6maw7srspgwc";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["setVars" "doConfigure" "doMakeInstall"];
  configureFlags = [
    "--enable-h323"
  ];
  setVars = a.noDepEntry (''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D__STDC_CONSTANT_MACROS=1"
  '');
      
  meta = {
    description = "OPAL VoIP library";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://ftp.gnome.org/pub/GNOME/sources/opal";
    };
  };
}) x

