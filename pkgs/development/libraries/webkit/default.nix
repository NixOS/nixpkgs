args : with args; 
let 
  s = import ./src-for-default.nix;
  version = lib.attrByPath ["version"] s.version args;
in
rec {
  src = fetchurl {
    url = s.url;
    sha256 = s.hash;
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
    # WML support causes crash on
    # Slashdot.org. It is fixed upstream,
    # but the required update is too big
    # Let us wait for a GTK release..
    #"--enable-wml"
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
    maintainers = [stdenv.lib.maintainers.raskin];
  };
  passthru = {
    inherit gstreamer gstPluginsBase gstPluginsGood gstFfmpeg;
  };
}
