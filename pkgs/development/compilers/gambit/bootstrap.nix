{ stdenv, fetchurl, autoconf, git, ... }:

stdenv.mkDerivation rec {
  name    = "gambit-bootstrap-${version}";
  version = "4.9.1";
  tarball_version = "v4_9_1";

  src = fetchurl {
    url    = "http://www.iro.umontreal.ca/~gambit/download/gambit/v4.9/source/gambit-${tarball_version}.tgz";
    sha256 = "14x9xa0yh7187alzw2m937jnh4csj0dyywi3va8bhi7aaw4p5qai";
  };

  buildInputs = [ autoconf ];

  configurePhase = ''
    ./configure --prefix=$out
  '';

  buildPhase = ''
    # Copy the (configured) sources now, not later, so we don't have to filter out
    # all the intermediate build products.
    mkdir -p $out ; cp -rp . $out/

    # build the gsc-boot* compiler
    make bootstrap
  '';

  installPhase = ''
    cp -fa ./ $out/
  '';

  forceShare = [ "info" ];

  meta = {
    description = "Optimizing Scheme to C compiler, bootstrap step";
    homepage    = "http://gambitscheme.org";
    license     = stdenv.lib.licenses.lgpl2;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice raskin fare ];
  };
}
