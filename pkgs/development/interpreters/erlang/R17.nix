{ stdenv, fetchurl, perl, gnum4, ncurses, openssl
, gnused, gawk, makeWrapper
, odbcSupport ? false, unixODBC ? null
, wxSupport ? false, mesa ? null, wxGTK ? null, xlibs ? null }:

assert wxSupport -> mesa != null && wxGTK != null && xlibs != null;
assert odbcSupport -> unixODBC != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "erlang-" + version + "${optionalString odbcSupport "-odbc"}";
  version = "17.4";

  src = fetchurl {
    url = "http://www.erlang.org/download/otp_src_${version}.tar.gz";
    sha256 = "0mhzfs64wa00g0bv9hwf0sbl8lgs83jj8cq9c3wg1iksmskfv0hd";
  };

  buildInputs =
    [ perl gnum4 ncurses openssl makeWrapper
    ] ++ optional wxSupport [ mesa wxGTK xlibs.libX11 ]
      ++ optional odbcSupport [ unixODBC ];

  patchPhase = '' sed -i "s@/bin/rm@rm@" lib/odbc/configure erts/configure '';

  preConfigure = ''
    export HOME=$PWD/../
    sed -e s@/bin/pwd@pwd@g -i otp_build
  '';

  configureFlags= "--with-ssl=${openssl} ${optionalString odbcSupport "--with-odbc=${unixODBC}"} ${optionalString stdenv.isDarwin "--enable-darwin-64bit"}";

  postInstall = let
    manpages = fetchurl {
      url = "http://www.erlang.org/download/otp_doc_man_${version}.tar.gz";
      sha256 = "0n4sczblx8mjcck56rpxvyvz186hkzg0c1xjqrnpnz1nkn7dn73c";
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
