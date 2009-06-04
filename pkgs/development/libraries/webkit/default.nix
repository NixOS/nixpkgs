args : with args; 
let version = lib.attrByPath ["version"] "r44341" args; in
rec {
  src = fetchurl {
    url = "http://nightly.webkit.org/files/trunk/src/WebKit-${version}.tar.bz2";
    sha256 = "17byp4v47xk6xdxq6adpf0b9vswasrhj4f5pw0y2z80lgd1sxcly";
  };

  buildInputs = [gtk atk cairo curl fontconfig freetype
    gettext libjpeg libpng libtiff libxml2 libxslt pango
    sqlite icu gperf bison flex autoconf automake libtool 
    perl intltool pkgconfig libsoup gtkdoc libXt libproxy
    enchant gstreamer gstPluginsBase gstFfmpeg
    ];

  configureCommand = "./autogen.sh ";
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["setVars" "paranoidFixComments" "doConfigure" (doPatchShebangs ".") 
    "doReplaceUsrBin" "doMakeInstall" "doAddPrograms"];

  setVars = fullDepEntry (''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lXt"
  '') ["minInit"];

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
      
  paranoidFixComments = fullDepEntry (''
    sed -re 's@( |^)//.*@/* & */@' -i $(find . -name '*.c' -o -name '*.h')
  '') ["minInit" "doUnpack"];

  name = "webkit-" + version;
  meta = {
    description = "WebKit - a fast and correct HTML renderer";
  };
}
