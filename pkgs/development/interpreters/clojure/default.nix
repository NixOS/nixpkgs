{ stdenv, fetchurl, jdk, rlwrap, makeWrapper }:

stdenv.mkDerivation rec {
  name = "clojure-${version}";
  version = "1.10.0.411";

  src = fetchurl {
    url = "https://download.clojure.org/install/clojure-tools-${version}.tar.gz";
    sha256 = "00bhn6w9iwhgmyx89lk97q19phpm9vh45m3m1pi7d31gldb6v0zh";
  };

  buildInputs = [ makeWrapper ];

  outputs = [ "out" "prefix" ];

  installPhase = let
    binPath = stdenv.lib.makeBinPath [ rlwrap jdk ];
  in ''
    mkdir -p $prefix/libexec
    cp clojure-tools-${version}.jar $prefix/libexec
    cp {,example-}deps.edn $prefix

    substituteInPlace clojure --replace PREFIX $prefix

    install -Dt $out/bin clj clojure
    wrapProgram $out/bin/clj --prefix PATH : $out/bin:${binPath}
    wrapProgram $out/bin/clojure --prefix PATH : $out/bin:${binPath}
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
