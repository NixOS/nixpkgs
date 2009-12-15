args :  
let 
  lib = args.lib;
  fetchurl = args.fetchurl;
  fullDepEntry = args.fullDepEntry;
  doPatchShebangs = args.doPatchShebangs;

  version = lib.attrByPath ["version"] "2008.03.30" args; 
  buildInputs = with args; [
    zlib sqlite gmp libffi cairo ncurses freetype mesa
    libpng libtiff libjpeg readline libsndfile libxml2
    freeglut e2fsprogs libsamplerate pcre libevent libedit
  ];
in
rec {
  src = /* Here a fetchurl expression goes */
    fetchurl {
      url = "http://github.com/stevedekorte/io/tarball/${version}";
      name = "io-${version}.tar.gz";
      sha256 = "1i1hcidcf93145jj1vwwa2jvp8lb25pn2kg0cb56a059narrqxlv";
    };

  inherit buildInputs;
  configureFlags = [];

  makeFlags = ["INSTALL_PREFIX=$out"];

  /* doConfigure should be specified separately */
  phaseNames = ["preBuild" "doMakeInstall" "postInstall" (doPatchShebangs "$out/share/io/samples") 
    (doPatchShebangs "$out/lib/io")];
      
  preBuild = fullDepEntry (''
    for i in $pkgs ${
        if args.stdenv ? glibc then args.stdenv.glibc else ""
      } ${
        if args ? libffi &&  args.libffi != null then "$(echo ${args.libffi}/lib/*/include/..)" else ""
      }; do
        echo "Path: $i"
        sed -i build/AddonBuilder.io -e '/"\/sw"/asearchPrefixes append("'"$i"'"); '
	sed -i addons/Flux/io/Flux.io -e 's@/usr/local/@'"$out/"'@g' 
    done
  '') ["minInit" "addInputs" "doUnpack"];

  postInstall = fullDepEntry (''
    ensureDir $out/share/io

    ln -s $out/lib/io/addons $out/share/io
    cp -r samples $out/share/io
  '') ["minInit" "doUnpack" "defEnsureDir" "doMakeInstall"];

  name = "io-" + version;
  meta = {
    description = "Io programming language";
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.linux;
  };
}
