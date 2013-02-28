args : with args; 
let 
  s = import ./src-for-default.nix; # 1.10 needs newer gtk3, wait for x-updates
  version = lib.attrByPath ["version"] s.version args;
in
rec {
  src = fetchurl {
    url = s.url;
    sha256 = s.hash;
  };

  buildInputs = [gtk gtk2 glib atk cairo curl fontconfig freetype
    gettext libjpeg libpng libtiff libxml2 libxslt pango
    sqlite icu gperf bison flex autoconf automake libtool 
    perl intltool pkgconfig libsoup gtkdoc libXt libproxy
    enchant python ruby which renderproto libXrender geoclue
    kbproto mesa
    ];

  propagatedBuildInputs = [
    gstreamer gst_plugins_base gst_ffmpeg gst_plugins_good
    ];

  configureFlags = [
    "--enable-3D-transforms"
    "--enable-web-sockets"
    "--enable-web-timing"
    
    "--enable-geolocation"

    # Not implemented?
    #"--enable-web-audio"

    "--enable-mathml"

    #"--enable-wml"
    
    # https://bugs.webkit.org/show_bug.cgi?id=45110
    #"--enable-indexed-database"

    # Doesn't work in release...
    #"--enable-xhtmlmp"

    # "--enable-input-speech"

    "--enable-file-writer"
    "--enable-blob"

    # https://bugs.webkit.org/show_bug.cgi?id=59430
    #"--enable-directory-upload"

    # https://bugs.webkit.org/show_bug.cgi?id=58443
    #"--enable-file-system"
    ];

  /* doConfigure should be specified separately */
  phaseNames = ["setVars" "doPatch" "fixConfigure" /* "paranoidFixComments" */ "doConfigure" (doPatchShebangs ".") 
    "doReplaceUsrBin" "doMakeInstall" "doAddPrograms"];

  setVars = fullDepEntry (''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lXt"
  '') ["minInit"];

  patches = [ ./bison26.patch ]; # http://trac.webkit.org/changeset/124099
  patchFlags = "-p2";

  doReplaceUsrBin = fullDepEntry (''
    for i in $(find . -name '*.pl') $(find . -name '*.pm'); do 
        sed -e 's@/usr/bin/gcc@gcc@' -i $i
    done
  '') ["minInit" "doUnpack"];

  doAddPrograms = fullDepEntry (''
    mkdir -p $out/bin
    for i in Programs/.libs/* Programs/*; do 
        cp $i $out/bin/webkit-program-$(basename $i) || true
    done
  '') ["minInit" "doMake" "defEnsureDir"];
      
  paranoidFixComments = fullDepEntry (''
    sed -re 's@( |^)//.*@/* & */@' -i $(find . -name '*.c' -o -name '*.h')
  '') ["minInit" "doUnpack"];

  # See http://archive.linuxfromscratch.org/mail-archives/blfs-dev/2012-April/022893.html
  fixConfigure = fullDepEntry (''
    sed   -i -e 's/=GSTREAMER_0_10_REQUIRED_VERSION/=\$GSTREAMER_0_10_REQUIRED_VERSION/' \
      -e 's/=GSTREAMER_0_10_PLUGINS_BASE_REQUIRED_VERSION/=\$GSTREAMER_0_10_PLUGINS_BASE_REQUIRED_VERSION/' \
      configure{,.ac}
  '') ["minInit" "doUnpack"];

  name = s.name;
  meta = {
    description = "WebKit - a fast and correct HTML renderer";
    maintainers = [stdenv.lib.maintainers.raskin];
  };
  passthru = {
    inherit gstreamer gst_plugins_base gst_plugins_good gst_ffmpeg libsoup;
  };
}
