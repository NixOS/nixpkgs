args: with args;

let

  inherit (args.composableDerivation) composableDerivation edf wwf;

  libs = [ mysql apacheHttpd zlib sqlite pcre apr gtk];

  includes = lib.concatMapStrings (x: ''"${x}/include",'' ) libs + ''"{gkt}/include/gtk-2.0",'';
  
in

composableDerivation {} ( fixed : {

  name = "neko-cvs";

  src = sourceByName "neko";

  # optionally remove apache mysql like gentoo does?
  # they just remove libs/{apache,mod_neko}
  buildInputs = [boehmgc pkgconfig makeWrapper] ++ libs;
  # apr should be in apacheHttpd propagatedBuildInputs

  preConfigure = ''
    sed -i \
      -e 's@"/usr/include",@${includes}@' \
      src/tools/install.neko
    sed -i "s@/usr/local@$out@" Makefile
    ensureDir $out/{bin,lib}
  '';

  inherit zlib;

  meta = { 
    description = "Neko is an high-level dynamicly typed programming language";
    homepage = http://nekovm.org;
    license = ["GPLv2" ];  # -> docs/license.txt
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };

  # if stripping was done neko and nekoc would be the same. ?!
  dontStrip = 1;

  postInstall = ''
    wrapProgram "$out/bin/nekoc" \
      --set "LD_LIBRARY_PATH" $out/lib/neko \
  
    wrapProgram "$out/bin/neko" \
      --set "LD_LIBRARY_PATH" $out/lib/neko \
  '';

  # TODO make them optional and make them work 
  patches = [ ./disable-modules.patch ];
})
