{ stdenv, fetchurl, fetchgit, git, openssl, autoconf, pkgs }:

stdenv.mkDerivation rec {
  name    = "gambit-${version}";
  version = "4.8.8-f3ffeb6";
  bootstrap = import ./bootstrap.nix ( pkgs );

#  devver  = "4_8_8";
#  src = fetchurl {
#    url    = "http://www.iro.umontreal.ca/~gambit/download/gambit/v4.8/source/gambit-v${version}-devel.tgz";
#    sha256 = "0j3ka76cfb007rlcc3nv5p1s6vh31cwp87hwwabawf16vs1jb7bl";
#  };
  src = fetchgit {
    url = "https://github.com/feeley/gambit.git";
    rev = "f3ffeb695aeea80c18c1b9ef276b57898c780dca";
    sha256 = "1lqixsrgk9z2gj6z1nkys0pfd3m5zjxrp3gvqn2wpr9h7hjb8x06";
  };

  buildInputs = [ openssl git autoconf bootstrap ];

  configurePhase = ''
    options=(
      --prefix=$out
      --enable-single-host
      --enable-c-opt=-O2
      --enable-gcc-opts
      --enable-shared
      --enable-absolute-shared-libs # Yes, NixOS will want an absolute path, and fix it.
      --enable-poll
      --enable-openssl

      #--enable-multiple-versions # Nope, NixOS already does version multiplexing
      #--enable-guide
      #--enable-track-scheme
      #--enable-high-res-timing
      #--enable-max-processors=4
      #--enable-multiple-vms
      #--enable-dynamic-tls
      #--enable-multiple-vms
      #--enable-multiple-threaded-vms  ## when SMP branch is merged in
      #--enable-thread-system=posix    ## default when --enable-multiple-vms is on.
      #--enable-profile
      #--enable-coverage
      #--enable-inline-jumps
      #--enable-char-size=1" ; default is 4
    )
    ./configure ''${options[@]}
  '';

  buildPhase = ''
    # Make bootstrap compiler, from release bootstrap
    mkdir -p boot/wip-compiler &&
    cp -rp ${bootstrap}/. boot/wip-compiler/. &&
    chmod -R u+w boot &&
    cd boot/wip-compiler && \
    cp ../../gsc/makefile.in ../../gsc/*.scm gsc && \
    (cd gsc && make bootclean ) &&
    make bootstrap &&
    cd ../.. &&
    cp boot/wip-compiler/gsc/gsc gsc-boot &&

    # Now use the bootstrap compiler to build the real thing!
    make -j2 from-scratch
  '';

  doCheck = true;

  meta = {
    description = "Optimizing Scheme to C compiler";
    homepage    = "http://gambitscheme.org";
    license     = stdenv.lib.licenses.lgpl2;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice raskin fare ];
  };
}
