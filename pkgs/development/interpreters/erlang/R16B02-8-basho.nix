{ stdenv, fetchurl, fetchFromGitHub, perl, gnum4, ncurses, openssl, autoconf264, gcc, erlang
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
  version = "16B02";

  src = fetchFromGitHub {
    owner = "basho";
    repo = "otp";
    rev = "OTP_R16B02_basho8";
    sha256 = "1w0hbm0axxxa45v3kl6bywc9ayir5vwqxjpnjlzc616ldszb2m0x";
  };

  debugInfo = enableDebugInfo;

  buildInputs =
    [ perl gnum4 ncurses openssl makeWrapper autoconf264 gcc 
    ] ++ optional wxSupport [ mesa wxGTK xorg.libX11 ]
      ++ optional odbcSupport [ unixODBC ]
      ++ optionals stdenv.isDarwin [ Carbon Cocoa ];

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
      sha256 = "12apxjmmd591y9g9bhr97z5jbd1jarqg7wj0y2sqhl21hc1yp75p";
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
