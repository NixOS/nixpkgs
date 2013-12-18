{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  version = "1.5.1";
  name = "clojure-binary-${version}";

  src = fetchurl {
    url = "http://repo1.maven.org/maven2/org/clojure/clojure/${version}/clojure-${version}.zip";
    sha256 = "1qgiji6ddvv40khp3qb3xfz09g7p4nnsh3pywqglb9f16v534yzy";
  };


  buildInputs = [ unzip ];

  phases = "unpackPhase installPhase";

  installPhase = "
    mkdir -p $out/lib/java
    cp clojure-${version}.jar clojure.jar
    install -t $out/lib/java clojure.jar
  ";

  meta = {
    description = "a Lisp dialect for the JVM";
    homepage = http://clojure.org/;
    license = stdenv.lib.licenses.bsd3;
    longDescription = ''
      Clojure is a dynamic programming language that targets the Java
      Virtual Machine. It is designed to be a general-purpose language,
      combining the approachability and interactive development of a
      scripting language with an efficient and robust infrastructure for
      multithreaded programming. Clojure is a compiled language - it
      compiles directly to JVM bytecode, yet remains completely
      dynamic. Every feature supported by Clojure is supported at
      runtime. Clojure provides easy access to the Java frameworks, with
      optional type hints and type inference, to ensure that calls to Java
      can avoid reflection.

      Clojure is a dialect of Lisp, and shares with Lisp the code-as-data
      philosophy and a powerful macro system. Clojure is predominantly a
      functional programming language, and features a rich set of immutable,
      persistent data structures. When mutable state is needed, Clojure
      offers a software transactional memory system and reactive Agent
      system that ensure clean, correct, multithreaded designs.
    '';
  };
}
