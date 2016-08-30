{ stdenv, fetchurl, perl, gnum4, ncurses, openssl
, makeWrapper, gnused, gawk }:

let version = "14B04"; in

stdenv.mkDerivation {
  name = "erlang-" + version;

  src = fetchurl {
    url = "http://www.erlang.org/download/otp_src_R${version}.tar.gz";
    sha256 = "0vlvjlg8vzcy6inb4vj00bnj0aarvpchzxwhmi492nv31s8kb6q9";
  };

  buildInputs = [ perl gnum4 ncurses openssl makeWrapper ];

  patchPhase = '' sed -i "s@/bin/rm@rm@" lib/odbc/configure erts/configure '';

  preConfigure = ''
    export HOME=$PWD/../
    sed -e s@/bin/pwd@pwd@g -i otp_build
  '';

  configureFlags = "--with-ssl=${openssl.dev}";

  hardeningDisable = [ "format" ];

  postInstall = let
    manpages = fetchurl {
      url = "http://www.erlang.org/download/otp_doc_man_R${version}.tar.gz";
      sha256 = "1nh7l7wilyyaxvlwkjxgm3cq7wpd90sk6vxhgpvg7hwai8g52545";
    };
  in ''
    tar xf "${manpages}" -C "$out/lib/erlang"
    for i in "$out"/lib/erlang/man/man[0-9]/*.[0-9]; do
      prefix="''${i%/*}"
      ensureDir "$out/share/man/''${prefix##*/}"
      ln -s "$i" "$out/share/man/''${prefix##*/}/''${i##*/}erl"
    done
  '';

  # Some erlang bin/ scripts run sed and awk
  postFixup = ''
    wrapProgram $out/lib/erlang/bin/erl --prefix PATH ":" "${gnused}/bin/"
    wrapProgram $out/lib/erlang/bin/start_erl --prefix PATH ":" "${gnused}/bin/:${gawk}/bin"
  '';

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = "http://www.erlang.org/";
    description = "Programming language used for massively scalable soft real-time systems";

    longDescription = ''
      Erlang is a programming language used to build massively scalable
      soft real-time systems with requirements on high availability.
      Some of its uses are in telecoms, banking, e-commerce, computer
      telephony and instant messaging. Erlang's runtime system has
      built-in support for concurrency, distribution and fault
      tolerance.
    '';

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
