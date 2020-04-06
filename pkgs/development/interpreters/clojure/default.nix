{ stdenv, fetchurl, jdk11, rlwrap, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "clojure";
  version = "1.10.1.507";

  src = fetchurl {
    url = "https://download.clojure.org/install/clojure-tools-${version}.tar.gz";
    sha256 = "1k0jwa3481g3mkalwlb9gkcz9aq9zjpwmzckv823fr2d8djp41cc";
  };

  patches = [ ./TDEPS-150.patch ];

  buildInputs = [ makeWrapper ];

  installPhase =
    let
      binPath = stdenv.lib.makeBinPath [ rlwrap jdk11 ];
    in
      ''
        mkdir -p $out/libexec
        cp clojure-tools-${version}.jar $out/libexec
        cp example-deps.edn $out
        cp deps.edn $out

        substituteInPlace clojure --replace PREFIX $out

        install -Dt $out/bin clj clojure
        wrapProgram $out/bin/clj --prefix PATH : $out/bin:${binPath}
        wrapProgram $out/bin/clojure --prefix PATH : $out/bin:${binPath}
      '';

  doInstallCheck = true;
  installCheckPhase = ''
    CLJ_CONFIG=$out CLJ_CACHE=$out/libexec $out/bin/clojure \
      -Spath \
      -Sverbose \
      -Scp $out/libexec/clojure-tools-${version}.jar
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
    maintainers = with maintainers; [ jlesquembre ];
    platforms = platforms.unix;
  };
}
