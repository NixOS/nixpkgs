{ stdenv, fetchurl, perl, gnum4, ncurses, openssl
, gnused, gawk, makeWrapper
, odbcSupport ? false, unixODBC ? null
, wxSupport ? false, mesa ? null, wxGTK ? null, xorg ? null
, enableDebugInfo ? false
, Carbon ? null, Cocoa ? null }:

assert wxSupport -> mesa != null && wxGTK != null && xorg != null;
assert odbcSupport -> unixODBC != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "erlang-" + version + "${optionalString odbcSupport "-odbc"}";
  version = "16B03-1";

  src = fetchurl {
    url = "http://www.erlang.org/download/otp_src_R${version}.tar.gz";
    sha256 = "1rvyfh22g1fir1i4xn7v2md868wcmhajwhfsq97v7kn5kd2m7khp";
  };

  debugInfo = enableDebugInfo;

  buildInputs =
    [ perl gnum4 ncurses openssl makeWrapper
    ] ++ optionals wxSupport [ mesa wxGTK xorg.libX11 ]
      ++ optional odbcSupport unixODBC
      ++ optionals stdenv.isDarwin [ Carbon Cocoa ];

  # Clang 4 (rightfully) thinks signed comparisons of pointers with NULL are nonsense
  prePatch = ''
    substituteInPlace lib/wx/c_src/wxe_impl.cpp --replace 'temp > NULL' 'temp != NULL'
  '';

  patchPhase = '' sed -i "s@/bin/rm@rm@" lib/odbc/configure erts/configure '';

  preConfigure = ''
    export HOME=$PWD/../
    sed -e s@/bin/pwd@pwd@g -i otp_build
  '';

  configureFlags= "--with-ssl=${openssl.dev} ${optionalString odbcSupport "--with-odbc=${unixODBC}"} ${optionalString stdenv.isDarwin "--enable-darwin-64bit"}";

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
    wrapProgram $out/lib/erlang/bin/start_erl --prefix PATH ":" "${stdenv.lib.makeBinPath [ gnused gawk ]}"
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

    platforms = platforms.unix;
    maintainers = [ maintainers.the-kenny ];
  };
}
