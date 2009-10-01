{ fetchurl, stdenv, ant, javac, jvm }:

let
  version = "2.9.1";
  tools   = fetchurl {
    url = "mirror://apache/xerces/j/source/Xerces-J-tools.${version}.tar.gz";
    sha256 = "1zzbq9ijy0f3v8w2sws9w79bkda34m9i01993md94n8fccnkiwac";
  };
  options = "-Dbuild.compiler=gcj";   # FIXME: We assume GCJ here.
in
  stdenv.mkDerivation {
    name = "xerces-j-${version}";

    src = fetchurl {
      url = "mirror://apache/xerces/j/source/Xerces-J-src.2.9.1.tar.gz";
      sha256 = "14h5jp58999f0rg4mkyab015hkgsxa8n6cx53ia0sjialxi01bqk";
    };

    buildInputs = [ ant javac jvm ];

    configurePhase = "tar xzvf ${tools}";
    buildPhase     = "ant ${options} jar";

    # The `tests' directory is missing from the tarball.
    doCheck = false;

    # FIXME: Install javadoc as well.
    installPhase =
      '' ensureDir "$out/lib/java"
         cp -v build/xerces*.jar "$out/lib/java"
      '';

    meta = {
      description = "Apache Xerces, an XML parser for Java";

      longDescription =
        '' Xerces2 Java is a library for parsing, validating and manipulating
           XML documents.

           Xerces 2.x introduced the Xerces Native Interface (XNI), a
           complete framework for building parser components and
           configurations that is extremely modular and easy to program.  XNI
           is merely an internal set of interfaces.  There is no need for an
           XML application programmer to learn XNI if they only intend to
           interface to the Xerces2 parser using standard interfaces like
           JAXP, DOM, and SAX.  Xerces developers and application developers
           that need more power and flexibility than that provided by the
           standard interfaces should read and understand XNI.
        '';

      homepage = http://xerces.apache.org/xerces2-j/;

      license = "Apache-2.0";

      maintainers = [ stdenv.lib.maintainers.ludo ];
    };
  }
