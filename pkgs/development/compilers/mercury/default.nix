{
  lib,
  stdenv,
  fetchurl,
  gcc,
  flex,
  bison,
  texinfo,
  jdk_headless,
  erlang,
  makeWrapper,
  readline,
}:

stdenv.mkDerivation rec {
  pname = "mercury";
  version = "22.01.8";

  src = fetchurl {
    url = "https://dl.mercurylang.org/release/mercury-srcdist-${version}.tar.gz";
    sha256 = "sha256-oJfozI7KAVLtlSfByvc+XJyD9q2h0xOiW4D+eQcvutg=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    gcc
    flex
    bison
    texinfo
    jdk_headless
    erlang
    readline
  ];

  patchPhase = ''
    # Fix calls to programs in /bin
    for p in uname pwd ; do
      for f in $(egrep -lr /bin/$p *) ; do
        sed -i 's@/bin/'$p'@'$p'@g' $f ;
      done
    done
  '';

  preConfigure = ''
    mkdir -p $out/lib/mercury/cgi-bin ;
    configureFlags="--enable-deep-profiler=$out/lib/mercury/cgi-bin";
  '';

  preBuild = ''
    # Mercury buildsystem does not take -jN directly.
    makeFlags="PARALLEL=-j$NIX_BUILD_CORES" ;
  '';

  postInstall = ''
    # Wrap with compilers for the different targets.
    for e in $(ls $out/bin) ; do
      wrapProgram $out/bin/$e \
        --prefix PATH ":" "${gcc}/bin" \
        --prefix PATH ":" "${jdk_headless}/bin" \
        --prefix PATH ":" "${erlang}/bin"
    done
  '';

  meta = {
    description = "A pure logic programming language";
    longDescription = ''
      Mercury is a logic/functional programming language which combines the
      clarity and expressiveness of declarative programming with advanced
      static analysis and error detection features.  Its highly optimized
      execution algorithm delivers efficiency far in excess of existing logic
      programming systems, and close to conventional programming systems.
      Mercury addresses the problems of large-scale program development,
      allowing modularity, separate compilation, and numerous optimization/time
      trade-offs.
    '';
    homepage = "https://mercurylang.org/";
    changelog = "https://dl.mercurylang.org/release/release-notes-${version}.html";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
