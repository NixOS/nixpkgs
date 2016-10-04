{ stdenv, fetchurl, fetchFromGitHub, perl, gnum4, ncurses, openssl
, gnused, gawk, autoconf, libxslt, libxml2, makeWrapper
, Carbon, Cocoa
, odbcSupport ? false, unixODBC ? null
, wxSupport ? true, mesa ? null, wxGTK ? null, xorg ? null, wxmac ? null
, javacSupport ? false, openjdk ? null
, enableHipe ? true
, enableDebugInfo ? false
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
  version = "18.3.4";

  # Minor OTP releases are not always released as tarbals at
  # http://erlang.org/download/ So we have to download from
  # github. And for the same reason we can't use a prebuilt manpages
  # tarball and need to build manpages ourselves.
  src = fetchFromGitHub {
    owner = "erlang";
    repo = "otp";
    rev = "OTP-${version}";
    sha256 = "1f8nhybzsdmjvkmkzpjj3wj9jzx8mihlvi6gfp47fxkalansz39h";
  };

  buildInputs =
    [ perl gnum4 ncurses openssl autoconf libxslt libxml2 makeWrapper
    ] ++ optionals wxSupport (if stdenv.isDarwin then [ wxmac ] else [ mesa wxGTK xorg.libX11 ])
      ++ optional odbcSupport unixODBC
      ++ optional javacSupport openjdk
      ++ stdenv.lib.optionals stdenv.isDarwin [ Carbon Cocoa ];

  debugInfo = enableDebugInfo;

  rmAndPwdPatch = fetchurl {
     url = "https://github.com/erlang/otp/commit/98b8650d22e94a5ff839170833f691294f6276d0.patch";
     sha256 = "0cd5pkqrigiqz6cyma5irqwzn0bi17k371k9vlg8ir31h3zmqfip";
  };

  envAndCpPatch = fetchurl {
     url = "https://github.com/binarin/otp/commit/9f9841eb7327c9fe73e84e197fd2965a97b639cf.patch";
     sha256 = "10h5348p6g279b4q01i5jdqlljww5chcvrx5b4b0dv79pk0p0m9f";
  };

  patches = [
    rmAndPwdPatch
    envAndCpPatch
  ];

  preConfigure = ''
    ./otp_build autoconf
  '';

  configureFlags= [
    "--with-ssl=${openssl.dev}"
  ] ++ optional enableHipe "--enable-hipe"
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
