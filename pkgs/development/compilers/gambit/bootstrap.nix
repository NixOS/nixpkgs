{ stdenv, fetchurl, autoconf, git, ... }:

stdenv.mkDerivation rec {
  name    = "gambit-bootstrap-${version}";
  version = "4.9.2";
  tarball_version = "v4_9_2";

  src = fetchurl {
    url    = "http://www.iro.umontreal.ca/~gambit/download/gambit/v4.9/source/gambit-${tarball_version}.tgz";
    sha256 = "1cpganh3jgjdw6qsapcbwxdbp1xwgx5gvdl4ymwf8p2c5k018dwy";
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
