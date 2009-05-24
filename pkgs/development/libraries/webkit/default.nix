args : with args; 
let version = lib.attrByPath ["version"] "r34824" args; in
rec {
  src = fetchurl {
    url = "http://nightly.webkit.org/files/trunk/src/WebKit-${version}.tar.bz2";
    sha256 = "10h295niz1np0rfjqchvjda8kdxf9z0qrk2r3x8xbrbva1y6dfn6";
  };

  buildInputs = [gtk atk cairo curl fontconfig freetype
    gettext libjpeg libpng libtiff libxml2 libxslt pango
    sqlite icu gperf bison flex autoconf automake libtool 
    perl intltool pkgconfig];

  configureCommand = "./autogen.sh ";
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["doConfigure" (doPatchShebangs ".") "doReplaceUsrBin" "doMakeInstall" "doAddPrograms"];

  doReplaceUsrBin = fullDepEntry (''
    for i in $(find . -name '*.pl') $(find . -name '*.pm'); do 
        sed -e 's@/usr/bin/gcc@gcc@' -i $i
    done
  '') ["minInit" "doUnpack"];

  doAddPrograms = fullDepEntry (''
    for i in Programs/.libs/*; do 
        cp $i $out/bin/webkit-program-$(basename $i)
    done
  '') ["minInit" "doMake" "defEnsureDir"];
      
  name = "webkit-" + version;
  meta = {
    description = "WebKit - a fast and correct HTML renderer";
  };
}
