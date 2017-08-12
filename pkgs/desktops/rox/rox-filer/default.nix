{ stdenv, fetchurl, pkgconfig, libxml2, gtk, libSM, shared_mime_info, hicolor_icon_theme }:

let
  version = "2.11";
  name = "rox-filer-${version}";
in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/rox/rox-filer-${version}.tar.bz2";
    sha256 = "a929bd32ee18ef7a2ed48b971574574592c42e34ae09f36604bf663d7c101ba8";
  };

  buildInputs = [ pkgconfig libxml2 gtk shared_mime_info hicolor_icon_theme libSM ];

  patches = [
    ./rox-filer-2.11-in-source-build.patch
  ];

  # go to the source directory after unpacking the sources
  setSourceRoot = "export sourceRoot=rox-filer-${version}/ROX-Filer/";

  # patch source with defined patches
  patchFlags = "-p0";

  # patch the main.c to disable the lookup of the APP_DIR environment variable,
  # which is used to lookup the location for certain images when rox-filer
  # starts; rather override the location with an absolute path to the directory
  # where images are stored to prevent having to use a wrapper, which sets the
  # APP_DIR environment variable prior to starting rox-filer
  preConfigure = ''
    sed -i -e "s:g_strdup(getenv(\"APP_DIR\")):\"$out\":" src/main.c
    mkdir build
    cd build
  '';

  configureScript = "../src/configure";

  installPhase = ''
    mkdir -p "$out"
    cd ..
    cp -av Help Messages Options.xml ROX images style.css .DirIcon "$out"

    # create the man/ directory, which will be moved from $out to share/ in the fixup phase
    mkdir "$out/man/"
    cp -av ../rox.1 "$out/man/"

    # the main executable
    mkdir "$out/bin/"
    cp -v ROX-Filer "$out/bin/rox"

    # mime types
    mkdir -p "$out/ROX/MIME"
    cd "$out/ROX/MIME"
    ln -sv text-x-{diff,patch}.png
    ln -sv application-x-font-{afm,type1}.png
    ln -sv application-xml{,-dtd}.png
    ln -sv application-xml{,-external-parsed-entity}.png
    ln -sv application-{,rdf+}xml.png
    ln -sv application-x{ml,-xbel}.png
    ln -sv application-{x-shell,java}script.png
    ln -sv application-x-{bzip,xz}-compressed-tar.png
    ln -sv application-x-{bzip,lzma}-compressed-tar.png
    ln -sv application-x-{bzip-compressed-tar,lzo}.png
    ln -sv application-x-{bzip,xz}.png
    ln -sv application-x-{gzip,lzma}.png
    ln -sv application-{msword,rtf}.png
  '';

  meta = with stdenv.lib; {
    description = "Fast, lightweight, gtk2 file manager";
    homepage = http://rox.sourceforge.net/desktop;
    license = with licenses; [ gpl2 lgpl2 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.eleanor ];
  };
}
