{ stdenv, lib, fetchurl, flex, bison, texinfo, makeWrapper, readline
, enableErlang ? false, erlang
, enableJava ? false, jdk
, CoreFoundation
}:

stdenv.mkDerivation rec {
  pname = "mercury";
  version = "20.01";

  src = fetchurl {
    url    = "https://dl.mercurylang.org/release/mercury-srcdist-${version}.tar.gz";
    sha256 = "0m1mkr5zh0wc1fnlz8r3sqrb1vpqqy71ggxi4vmd546fiyzn5m64";
  };

  buildInputs = [ flex bison texinfo makeWrapper readline stdenv.cc ]
    ++ lib.optional stdenv.isDarwin CoreFoundation
    ++ lib.optional enableErlang erlang
    ++ lib.optional enableJava jdk;

  patchPhase = ''
    # Fix calls to programs in /bin
    for p in uname pwd ; do
      for f in $(egrep -lr /bin/$p *) ; do
        sed -i 's@/bin/'$p'@'$p'@g' $f ;
      done
    done
  '';

  preConfigure = ''
    mkdir -p $out/lib/mercury/cgi-bin
    configureFlags+=--enable-deep-profiler=$out/lib/mercury/cgi-bin
  '';
  configureFlags = []
    ++ lib.optional enableJava "--enable-java-grade"
    ++ lib.optional enableErlang "--enable-erlang-grade";

  preBuild = ''
    # Mercury buildsystem does not take -jN directly.
    makeFlags="PARALLEL=-j$NIX_BUILD_CORES" ;
  '';

  postFixup = ''
    # Wrap with compilers for the different targets.
    for e in $out/bin/* ; do
      wrapProgram $e --prefix PATH : ${lib.makeBinPath [ stdenv.cc ]}
  ''
  + lib.optionalString enableJava ''--prefix PATH : ${lib.makeBinPath [ jdk ]} ''
  + lib.optionalString enableErlang ''--prefix PATH : ${lib.makeBinPath [erlang]} ''
  + ''
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
    homepage    = "http://mercurylang.org";
    license     = lib.licenses.gpl2;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [ ];
  };
}
