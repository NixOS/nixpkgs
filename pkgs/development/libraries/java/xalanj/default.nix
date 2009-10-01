{ fetchurl, stdenv, ant, javac, jvm, xerces }:

let
  version = "2.7.1";
  options = "-Dbuild.compiler=gcj";   # FIXME: We assume GCJ here.
in
  stdenv.mkDerivation {
    name = "xerces-j-${version}";

    src = fetchurl {
      url = "mirror://apache/xml/xalan-j/source/xalan-j_2_7_1-src.tar.gz";
      sha256 = "0hxhx0n0ynflq1d01sma658ipwn3f3902x6n8mfk70mqkdiallps";
    };

    buildInputs = [ ant javac jvm xerces ];

    configurePhase =
      '' rm -v lib/xerces*.jar
         export CLASSPATH="${xerces}/lib/java"
      '';

    buildPhase = "ant ${options} jar";
    doCheck    = false;

    # FIXME: Install javadoc as well.
    installPhase =
      '' ensureDir "$out/lib/java"
         cp -v build/x*.jar "$out/lib/java"
      '';

    meta = {
      description = "Apache Xalan-Java, an XSLT processor";

      longDescription =
        '' Xalan-Java is an XSLT processor for transforming XML documents
           into HTML, text, or other XML document types.  It implements XSL
           Transformations (XSLT) Version 1.0 and XML Path Language (XPath)
           Version 1.0 and can be used from the command line, in an applet or a
           servlet, or as a module in other program.

           Xalan-Java implements the javax.xml.transform interface in Java
           API for XML Processing (JAXP) 1.3.  This interface provides a
           modular framework and a standard API for performing XML
           transformations, and utilizes system properties to determine which
           Transformer and which XML parser to use.

           Xalan-Java also implements the javax.xml.xpath interface in JAXP
           1.3, which provides an object-model neutral API for evaluation of
           XPath expressions and access to the evaluation environment.
        '';

      homepage = http://xml.apache.org/xalan-j/;
      license = "Apache-2.0";

      maintainers = [ stdenv.lib.maintainers.ludo ];
    };
  }
