{ stdenv, fetchurl, fetchFromGitHub, perl, gnum4, ncurses, openssl
, gnused, gawk, autoconf, libxslt, libxml2, makeWrapper
, Carbon, Cocoa
, odbcSupport ? false, unixODBC ? null
, wxSupport ? true, mesa ? null, wxGTK ? null, xorg ? null, wxmac ? null
, javacSupport ? false, openjdk ? null
, enableHipe ? true
, enableDebugInfo ? false
, enableDirtySchedulers ? false
}:

assert wxSupport -> (if stdenv.isDarwin
  then wxmac != null
  else mesa != null && wxGTK != null && xorg != null);

assert odbcSupport -> unixODBC != null;
assert javacSupport ->  openjdk != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "erlang-" + version + "${optionalString odbcSupport "-odbc"}"
  + "${optionalString javacSupport "-javac"}";
  version = "19.3";

  # Minor OTP releases are not always released as tarbals at
  # http://erlang.org/download/ So we have to download from
  # github. And for the same reason we can't use a prebuilt manpages
  # tarball and need to build manpages ourselves.
  src = fetchFromGitHub {
    owner = "erlang";
    repo = "otp";
    rev = "OTP-${version}";
    sha256 = "0pp2hl8jf4iafpnsmf0q7jbm313daqzif6ajqcmjyl87m5pssr86";
  };

  buildInputs =
    [ perl gnum4 ncurses openssl autoconf libxslt libxml2 makeWrapper
    ] ++ optionals wxSupport (if stdenv.isDarwin then [ wxmac ] else [ mesa wxGTK xorg.libX11 ])
      ++ optional odbcSupport unixODBC
      ++ optional javacSupport openjdk
      ++ stdenv.lib.optionals stdenv.isDarwin [ Carbon Cocoa ];

  debugInfo = enableDebugInfo;

  prePatch = ''
    substituteInPlace configure.in \
      --replace '`sw_vers -productVersion`' '10.10'
  '';

  preConfigure = ''
    ./otp_build autoconf
  '';

  configureFlags= [
    "--with-ssl=${openssl.dev}"
  ] ++ optional enableHipe "--enable-hipe"
    ++ optional enableDirtySchedulers "--enable-dirty-schedulers"
    ++ optional wxSupport "--enable-wx"
    ++ optional odbcSupport "--with-odbc=${unixODBC}"
    ++ optional javacSupport "--with-javac"
    ++ optional stdenv.isDarwin "--enable-darwin-64bit";

  # install-docs will generate and install manpages and html docs
  # (PDFs are generated only when fop is available).
  installTargets = "install install-docs";

  postInstall = ''
    ln -s $out/lib/erlang/lib/erl_interface*/bin/erl_call $out/bin/erl_call
  '';

  # Some erlang bin/ scripts run sed and awk
  postFixup = ''
    wrapProgram $out/lib/erlang/bin/erl --prefix PATH ":" "${gnused}/bin/"
    wrapProgram $out/lib/erlang/bin/start_erl --prefix PATH ":" "${stdenv.lib.makeBinPath [ gnused gawk ]}"
  '';

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = "http://www.erlang.org/";
    downloadPage = "http://www.erlang.org/download.html";
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
    maintainers = with maintainers; [ the-kenny sjmackenzie couchemar ];
    license = licenses.asl20;
  };
}
