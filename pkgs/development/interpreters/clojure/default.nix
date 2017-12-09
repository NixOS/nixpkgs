{ stdenv, fetchurl, jdk, makeWrapper, rlwrap }:

stdenv.mkDerivation rec {
  name = "clojure-${version}";
  version = "1.9.0";
  tools-version = "273";
  clj-tools = "clojure-tools-${version}.${tools-version}";

  src = fetchurl {
    url = "https://download.clojure.org/install/${clj-tools}.tar.gz";
    sha256 = "0xmrq3xvr002jgq8m1j0y5ld0rcr49608g3gqxgyxzjqswacglb4";
  };

  buildInputs = [ jdk makeWrapper ];

  buildPhase = null;

  installPhase = ''
    mkdir -p $out/clojure/libexec $out/bin
    cp -t $out/clojure/libexec ${clj-tools}.jar
    cp -t $out/clojure deps.edn example-deps.edn

    sed -i -e "s@PREFIX@$out/clojure@g" clojure
    install -t $out/bin clojure clj

    wrapProgram $out/bin/clojure --set JAVA_CMD ${jdk.jre}/bin/java
    wrapProgram $out/bin/clj \
      --prefix PATH : "${stdenv.lib.makeBinPath [ rlwrap ]}" \
      --prefix PATH : "$out/bin"
  '';

  meta = with stdenv.lib; {
    description = "A Lisp dialect for the JVM";
    homepage = https://clojure.org/;
    license = licenses.epl10;
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
    maintainers = with maintainers; [ the-kenny ];
    platforms = platforms.unix;
  };
}
