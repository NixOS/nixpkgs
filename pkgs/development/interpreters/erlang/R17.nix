{ stdenv, fetchurl, perl, gnum4, ncurses, openssl
, gnused, gawk, makeWrapper
, wxSupport ? false, mesa ? null, wxGTK ? null, xlibs ? null }:

assert wxSupport -> mesa != null && wxGTK != null && xlibs != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "erlang-" + version;
  version = "17.0";

  src = fetchurl {
    url = "http://www.erlang.org/download/otp_src_${version}.tar.gz";
    sha256 = "1nyaka6238vh4kdgaynmg8hm5y5zj7hhyl1c971d2pjylsm2nzr9";
  };

  buildInputs =
    [ perl gnum4 ncurses openssl makeWrapper
    ] ++ optional wxSupport [ mesa wxGTK xlibs.libX11 ];

  patchPhase = '' sed -i "s@/bin/rm@rm@" lib/odbc/configure erts/configure '';

  preConfigure = ''
    export HOME=$PWD/../
    sed -e s@/bin/pwd@pwd@g -i otp_build
  '';

  configureFlags= "--with-ssl=${openssl} ${optionalString stdenv.isDarwin "--enable-darwin-64bit"}";

  postInstall = let
    manpages = fetchurl {
      url = "http://www.erlang.org/download/otp_doc_man_${version}.tar.gz";
      sha256 = "16dkz3w1q4ahy37c8a8r2h8zjcr7cxz7pd9z38chbxf6frc2pxxc";
    };
  in ''
    ln -s $out/lib/erlang/lib/erl_interface*/bin/erl_call $out/bin/erl_call
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

    platforms = platforms.unix;
    # Note: Maintainer of prev. erlang version was simons. If he wants
    # to continue maintaining erlang I'm totally ok with that.
    maintainers = [ maintainers.the-kenny ];
  };
}
