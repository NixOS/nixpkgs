{ pkgs, stdenv, fetchurl, fetchFromGitHub, makeWrapper, gawk, gnum4, gnused
, libxml2, libxslt, ncurses, openssl, perl, gcc, autoreconfHook
, openjdk ? null # javacSupport
, unixODBC ? null # odbcSupport
, mesa ? null, wxGTK ? null, wxmac ? null, xorg ? null # wxSupport
}:

{ baseName ? "erlang"
, version
, sha256 ? null
, rev ? "OTP-${version}"
, src ? fetchFromGitHub { inherit rev sha256; owner = "erlang"; repo = "otp"; }
, enableHipe ? true
, enableDebugInfo ? false
, enableThreads ? true
, enableSmpSupport ? true
, enableKernelPoll ? true
, javacSupport ? false, javacPackages ? [ openjdk ]
, odbcSupport ? false, odbcPackages ? [ unixODBC ]
, wxSupport ? true, wxPackages ? [ mesa wxGTK xorg.libX11 ]
, preUnpack ? "", postUnpack ? ""
, patches ? [], patchPhase ? "", prePatch ? "", postPatch ? ""
, configureFlags ? [], configurePhase ? "", preConfigure ? "", postConfigure ? ""
, buildPhase ? "", preBuild ? "", postBuild ? ""
, installPhase ? "", preInstall ? "", postInstall ? ""
, installTargets ? "install install-docs"
, checkPhase ? "", preCheck ? "", postCheck ? ""
, fixupPhase ? "", preFixup ? "", postFixup ? ""
, meta ? null
}:

assert wxSupport -> (if stdenv.isDarwin
  then wxmac != null
  else mesa != null && wxGTK != null && xorg != null);

assert odbcSupport -> unixODBC != null;
assert javacSupport -> openjdk != null;

let
  inherit (stdenv.lib) optional optionals optionalAttrs optionalString;
  wxPackages2 = if stdenv.isDarwin then [ wxmac ] else wxPackages;

in stdenv.mkDerivation ({
  name = "${baseName}-${version}"
    + optionalString javacSupport "-javac"
    + optionalString odbcSupport "-odbc";

  inherit src version;

  buildInputs =
   [ perl gnum4 ncurses openssl autoreconfHook libxslt libxml2 makeWrapper gcc
   ]
    ++ optionals wxSupport wxPackages2
    ++ optionals odbcSupport odbcPackages
    ++ optionals javacSupport javacPackages
    ++ optionals stdenv.isDarwin (with pkgs.darwin.apple_sdk.frameworks; [ Carbon Cocoa ]);

  debugInfo = enableDebugInfo;

  # Clang 4 (rightfully) thinks signed comparisons of pointers with NULL are nonsense
  prePatch = ''
    substituteInPlace lib/wx/c_src/wxe_impl.cpp --replace 'temp > NULL' 'temp != NULL'

    ${prePatch}
  '';

  postPatch = ''
    ${postPatch}

    patchShebangs make
  '';

  preConfigure = ''
    ./otp_build autoconf
  '';

  configureFlags = [ "--with-ssl=${openssl.dev}" ]
    ++ optional enableThreads "--enable-threads"
    ++ optional enableSmpSupport "--enable-smp-support"
    ++ optional enableKernelPoll "--enable-kernel-poll"
    ++ optional enableHipe "--enable-hipe"
    ++ optional javacSupport "--with-javac"
    ++ optional odbcSupport "--with-odbc=${unixODBC}"
    ++ optional wxSupport "--enable-wx"
    ++ optional stdenv.isDarwin "--enable-darwin-64bit";

  # install-docs will generate and install manpages and html docs
  # (PDFs are generated only when fop is available).

  postInstall = ''
    ${postInstall}

    ln -s $out/lib/erlang/lib/erl_interface*/bin/erl_call $out/bin/erl_call
  '';

  # Some erlang bin/ scripts run sed and awk
  postFixup = ''
    wrapProgram $out/lib/erlang/bin/erl --prefix PATH ":" "${gnused}/bin/"
    wrapProgram $out/lib/erlang/bin/start_erl --prefix PATH ":" "${stdenv.lib.makeBinPath [ gnused gawk ]}"
  '';

  setupHook = ./setup-hook.sh;

  meta = with stdenv.lib; {
    homepage = http://www.erlang.org/;
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
    maintainers = with maintainers; [ the-kenny sjmackenzie couchemar gleber ];
    license = licenses.asl20;
  };
}
// optionalAttrs (preUnpack != "")      { inherit preUnpack; }
// optionalAttrs (postUnpack != "")     { inherit postUnpack; }
// optionalAttrs (patches != [])        { inherit patches; }
// optionalAttrs (patchPhase != "")     { inherit patchPhase; }
// optionalAttrs (configureFlags != []) { inherit configureFlags; }
// optionalAttrs (configurePhase != "") { inherit configurePhase; }
// optionalAttrs (preConfigure != "")   { inherit preConfigure; }
// optionalAttrs (postConfigure != "")  { inherit postConfigure; }
// optionalAttrs (buildPhase != "")     { inherit buildPhase; }
// optionalAttrs (preBuild != "")       { inherit preBuild; }
// optionalAttrs (postBuild != "")      { inherit postBuild; }
// optionalAttrs (checkPhase != "")     { inherit checkPhase; }
// optionalAttrs (preCheck != "")       { inherit preCheck; }
// optionalAttrs (postCheck != "")      { inherit postCheck; }
// optionalAttrs (installPhase != "")   { inherit installPhase; }
// optionalAttrs (installTargets != "") { inherit installTargets; }
// optionalAttrs (preInstall != "")     { inherit preInstall; }
// optionalAttrs (fixupPhase != "")     { inherit fixupPhase; }
// optionalAttrs (preFixup != "")       { inherit preFixup; }
// optionalAttrs (postFixup != "")      { inherit postFixup; }
// optionalAttrs (meta != null)         { inherit meta; }
)
