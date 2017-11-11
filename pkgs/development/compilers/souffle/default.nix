{ stdenv, fetchFromGitHub, autoconf, automake, boost, bison, flex, openjdk, doxygen, perl, graphviz }:

stdenv.mkDerivation rec {
  version = "1.0.0";
  name    = "souffle-${version}";

  src = fetchFromGitHub {
    owner  = "souffle-lang";
    repo   = "souffle";
    rev    = version;
    sha256 = "13j14227dgxcm25z9iizcav563wg2ak9338pb03aqqz8yqxbmz4n";
  };

  buildInputs = [
    autoconf automake boost bison flex openjdk
    # Used for docs
    doxygen perl graphviz
  ];

  patchPhase = ''
    substituteInPlace configure.ac \
      --replace "m4_esyscmd([git describe --tags --abbrev=0 | tr -d '\n'])" "${version}"
  '';

  # Without this, we get an obscure error about not being able to find a library version
  # without saying what library it's looking for. Turns out it's searching global paths
  # for boost and failing there, so we tell it what's what here.
  configureFlags = [ "--with-boost-libdir=${boost}/lib" ];

  preConfigure = "./bootstrap";

  # in 1.0.0: parser.hh:40:0: error: unterminated #ifndef
  enableParallelBuilding = false;

  # See https://github.com/souffle-lang/souffle/issues/176
  hardeningDisable = [ "fortify" ];

  meta = with stdenv.lib; {
    description = "A translator of declarative Datalog programs into the C++ language";
    homepage    = "http://souffle-lang.github.io/";
    platforms   = platforms.unix;
    maintainers = with maintainers; [ copumpkin ];
    license     = licenses.upl;
  };
}
