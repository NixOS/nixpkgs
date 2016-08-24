{ stdenv, fetchurl, libantlr3c, jre, polarssl }:

let
  # We must use antlr-3.4 with belle-sip-1.4.0
  # We might be able to use antlr-3.5+ in the future
  antlr = fetchurl {
    url = "http://www.antlr3.org/download/antlr-3.4-complete.jar";
    sha256 = "1xqbam8vf04q5fasb0m2n1pn5dbp2yw763sj492ncq04c5mqcglx";
  };
in
stdenv.mkDerivation rec {
  name = "belle-sip-1.4.2";

  src = fetchurl {
    url = "mirror://savannah/linphone/belle-sip/${name}.tar.gz";
    sha256 = "0c48jh3kjz58swvx1m63ijx5x0c0hf37d803d99flk2l10kbfb42";
  };

  nativeBuildInputs = [ jre ];

  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  # belle-sip.pc doesn't have a library path for antlr3c or polarssl
  propagatedBuildInputs = [ libantlr3c polarssl ];

  postPatch = ''
    mkdir -p $TMPDIR/share/java
    cp ${antlr} $TMPDIR/share/java/antlr.jar

    sed -i "s,\(antlr_java_prefixes=\).*,\1\"$TMPDIR/share/java\"," configure
    cat configure | grep antlr_java
  '';

  configureFlags = [
    "--with-polarssl=${polarssl}"
  ];

  enableParallelBuild = true;

  meta = with stdenv.lib; {
    homepage = http://www.linphone.org/index.php/eng;
    description = "A Voice-over-IP phone";
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
