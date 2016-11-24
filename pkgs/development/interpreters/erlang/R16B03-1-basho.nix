{ stdenv, fetchurl, fetchgit, perl, gnum4, ncurses, openssl, autoconf264, gcc, erlang
, gnused, gawk, makeWrapper
, odbcSupport ? false, unixODBC ? null
, wxSupport ? false, mesa ? null, wxGTK ? null, xorg ? null
, enableDebugInfo ? false 
, Carbon ? null, Cocoa ? null }:

assert wxSupport -> mesa != null && wxGTK != null && xorg != null;
assert odbcSupport -> unixODBC != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "erlang-basho-" + version + "${optionalString odbcSupport "-odbc"}";
  version = "16B03-1";

  src = fetchgit {
    url = "https://github.com/basho/otp";
    rev = "cb3a485894e493ad172db2749129e613fe52713a";
    sha256 = "0xn28cxlq0ya1aww9q14rg8jf3x2flwxrz6wdnpb0l2h2dasr655";
  };

  debugInfo = enableDebugInfo;

  buildInputs =
    [ perl gnum4 ncurses openssl makeWrapper autoconf264 gcc 
    ] ++ optional wxSupport [ mesa wxGTK xorg.libX11 ]
      ++ optional odbcSupport [ unixODBC ];

  patchPhase = '' sed -i "s@/bin/rm@rm@" lib/odbc/configure.in erts/configure.in '';

  preConfigure = ''
    export HOME=$PWD/../
    export LANG=C
    export ERL_TOP=$(pwd)
    sed -e s@/bin/pwd@pwd@g -i otp_build
    sed -e s@"/usr/bin/env escript"@${erlang}/bin/escript@g -i lib/diameter/bin/diameterc 
  '';

  configureFlags= [
    "--with-ssl=${openssl.dev}"
    "--enable-smp-support" 
    "--enable-threads" 
    "--enable-kernel-poll" 
    "--disable-hipe" 
    "${optionalString odbcSupport "--with-odbc=${unixODBC}"}" 
    "${optionalString stdenv.isDarwin "--enable-darwin-64bit"}" 
    "${optionalString stdenv.isLinux "--enable-m64-build"}"
  ];

  buildPhase = ''
    ./otp_build autoconf 
    ./otp_build setup -a --prefix=$out $configureFlags
  '';

  postInstall = let
    manpages = fetchurl {
      url = "http://www.erlang.org/download/otp_doc_man_R${version}.tar.gz";
      sha256 = "17f3k5j17rdsah18gywjngip6cbfgp6nb9di6il4pahmf9yvqc8g";
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

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = "https://github.com/basho/otp/";
    description = "Programming language used for massively scalable soft real-time systems, Basho fork";

    longDescription = ''
      Erlang is a programming language used to build massively scalable
      soft real-time systems with requirements on high availability.
      Some of its uses are in telecoms, banking, e-commerce, computer
      telephony and instant messaging. Erlang's runtime system has
      built-in support for concurrency, distribution and fault
      tolerance.
      This version of Erlang is Basho's version, forked from Ericsson's 
      repository.
    '';

    platforms = ["x86_64-linux" "x86_64-darwin"];
    license = stdenv.lib.licenses.asl20;
    maintainers = with maintainers; [ mdaiter ];
  };
}
