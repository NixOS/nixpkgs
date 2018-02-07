{ stdenv, fetchurl, jdk, makeWrapper }:

let version = "1.9.0.273"; in

stdenv.mkDerivation {
  name = "clojure-${version}";

  src = fetchurl {
    url = "https://download.clojure.org/install/clojure-tools-${version}.tar.gz";
    sha256 = "0xmrq3xvr002jgq8m1j0y5ld0rcr49608g3gqxgyxzjqswacglb4";
  };

  buildInputs = [ jdk makeWrapper ];

  installPhase = ''
    pwd
    ls -la
    mkdir -p $out/libexec $out/bin
    cp -f deps.edn example-deps.edn $out
    cp -f clojure-tools-${version}.jar $out/libexec
    sed -i -e "s@PREFIX@$out@g" clojure
    cp -f clj clojure $out/bin
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
