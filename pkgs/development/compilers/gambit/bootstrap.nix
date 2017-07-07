{ stdenv, fetchurl, autoconf, ... }:

stdenv.mkDerivation rec {
  name    = "gambit-bootstrap-${version}";
  version = "4.8.8";
  tarball_version = "v4_8_8";

  src = fetchurl {
    url    = "http://www.iro.umontreal.ca/~gambit/download/gambit/v4.8/source/gambit-${tarball_version}-devel.tgz";
    sha256 = "075k2z04d6svxqf9paj3xvp0mm0xzy0vbma1y61s0lkywdim8xjz";
  };
  #src = fetchgit {
  #  url = "https://github.com/feeley/gambit.git";
  #  rev = "v${version}"; # 91d74e06939f0e1cf6ffdba4c14187d7c94bc08c
  #  sha256 = "0j3ka76cfb007rlcc3nv5p1s6vh31cwp87hwwabawf16vs1jb7bl";
  #};

  buildInputs = [ autoconf ];

  configurePhase = ''
    ./configure --prefix=$out --enable-single-host
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
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice raskin fare ];
  };
}
