{ fetchurl, stdenv, javac, jvm, antlr, pkgconfig, gtk, gconf }:

stdenv.mkDerivation rec {
  name = "classpath-0.99";

  src = fetchurl {
    url = "mirror://gnu/classpath/${name}.tar.gz";
    sha256 = "1j7cby4k66f1nvckm48xcmh352b1d1b33qk7l6hi7dp9i9zjjagr";
  };

  patches = [ ./missing-casts.patch ];

  buildInputs = [ javac jvm antlr pkgconfig gtk gconf ];

  configurePhase = ''
    # GCJ tries to compile all of Classpath during the `configure' run when
    # trying to build in the source tree (see
    # http://www.mail-archive.com/classpath@gnu.org/msg15079.html), thus we
    # build out-of-tree.
    mkdir ../build
    cd ../build
    echo "building in \`$PWD'"

    ../${name}/configure --prefix="$out"                        \
         --enable-fast-install --disable-dependency-tracking    \
         ${configureFlags}
  '';

  /* Plug-in support requires Xulrunner and all that.  Maybe someday,
     optionally.

    Compilation with `-Werror' is disabled because of this:

      native/jni/native-lib/cpnet.c: In function 'cpnet_addMembership':
      native/jni/native-lib/cpnet.c:583: error: dereferencing type-punned pointer will break strict-aliasing rules
      native/jni/native-lib/cpnet.c: In function 'cpnet_dropMembership':
      native/jni/native-lib/cpnet.c:598: error: dereferencing type-punned pointer will break strict-aliasing rules

   */

  configureFlags = "--disable-Werror --disable-plugin --with-antlr-jar=${antlr}/lib/antlr.jar";

  meta = {
    description = "GNU Classpath, essential libraries for Java";

    longDescription = ''
      GNU Classpath, Essential Libraries for Java, is a GNU project to create
      free core class libraries for use with virtual machines and compilers
      for the Java programming language.
    '';

    homepage = http://www.gnu.org/software/classpath/;

    # The exception makes it similar to LGPLv2+ AFAICS.
    license = "GPLv2+ + exception";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
