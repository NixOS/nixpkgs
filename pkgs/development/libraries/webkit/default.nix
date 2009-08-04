args : with args; 
let version = lib.attrByPath ["version"] "r46726" args; in
rec {
  src = fetchurl {
    url = "http://nightly.webkit.org/files/trunk/src/WebKit-${version}.tar.bz2";
    sha256 = "0nh47l7d0m0y7b3mn3s62pgx7xlxx7fy4j2x602xc7rqvfn46b6d";
  };

  buildInputs = [gtk atk cairo curl fontconfig freetype
    gettext libjpeg libpng libtiff libxml2 libxslt pango
    sqlite icu gperf bison flex autoconf automake libtool 
    perl intltool pkgconfig libsoup gtkdoc libXt libproxy
    enchant 
    ];

  propagatedBuildInputs = [
    gstreamer gstPluginsBase gstFfmpeg gstPluginsGood
    ];

  configureCommand = "./autogen.sh ";
  configureFlags = [
    "--enable-3D-transforms"
    "--enable-filters"
    "--enable-web-sockets"
    # Fails the build..
    # "--enable-shared-workers"
    "--enable-wml"
    ];

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
    ensureDir $out/bin
    for i in Programs/.libs/* Programs/*; do 
        cp $i $out/bin/webkit-program-$(basename $i) || true
    done
  '') ["minInit" "doMake" "defEnsureDir"];
      
  paranoidFixComments = fullDepEntry (''
    sed -re 's@( |^)//.*@/* & */@' -i $(find . -name '*.c' -o -name '*.h')
  '') ["minInit" "doUnpack"];

  name = "webkit-" + version;
  meta = {
    description = "WebKit - a fast and correct HTML renderer";
  };
  passthru = {
    inherit gstreamer gstPluginsBase gstPluginsGood gstFfmpeg;
  };
}
