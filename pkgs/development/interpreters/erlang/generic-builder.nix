{ pkgs, stdenv, fetchFromGitHub, makeWrapper, gawk, gnum4, gnused
, libxml2, libxslt, ncurses, openssl, perl, autoconf
# TODO: use jdk https://github.com/NixOS/nixpkgs/pull/89731
, openjdk8 ? null # javacSupport
, unixODBC ? null # odbcSupport
, libGL ? null, libGLU ? null, wxGTK ? null, wxmac ? null, xorg ? null # wxSupport
, parallelBuild ? false
, withSystemd ? stdenv.isLinux, systemd # systemd support in epmd
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
, javacSupport ? false, javacPackages ? [ openjdk8 ]
, odbcSupport ? false, odbcPackages ? [ unixODBC ]
, wxSupport ? true, wxPackages ? [ libGL libGLU wxGTK xorg.libX11 ]
, preUnpack ? "", postUnpack ? ""
, patches ? [], patchPhase ? "", prePatch ? "", postPatch ? ""
, configureFlags ? [], configurePhase ? "", preConfigure ? "", postConfigure ? ""
, buildPhase ? "", preBuild ? "", postBuild ? ""
, installPhase ? "", preInstall ? "", postInstall ? ""
, installTargets ? [ "install" "install-docs" ]
, checkPhase ? "", preCheck ? "", postCheck ? ""
, fixupPhase ? "", preFixup ? "", postFixup ? ""
, meta ? {}
}:

assert wxSupport -> (if stdenv.isDarwin
  then wxmac != null
  else libGL != null && libGLU != null && wxGTK != null && xorg != null);

assert odbcSupport -> unixODBC != null;
assert javacSupport -> openjdk8 != null;

let
  inherit (stdenv.lib) optional optionals optionalAttrs optionalString;
  wxPackages2 = if stdenv.isDarwin then [ wxmac ] else wxPackages;

in stdenv.mkDerivation ({
  name = "${baseName}-${version}"
    + optionalString javacSupport "-javac"
    + optionalString odbcSupport "-odbc";

  inherit src version;

  nativeBuildInputs = [ autoconf makeWrapper perl gnum4 libxslt libxml2 ];

  buildInputs = [ ncurses openssl ]
    ++ optionals wxSupport wxPackages2
    ++ optionals odbcSupport odbcPackages
    ++ optionals javacSupport javacPackages
    ++ optional withSystemd systemd
    ++ optionals stdenv.isDarwin (with pkgs.darwin.apple_sdk.frameworks; [ Carbon Cocoa ]);

  debugInfo = enableDebugInfo;

  # On some machines, parallel build reliably crashes on `GEN    asn1ct_eval_ext.erl` step
  enableParallelBuilding = parallelBuild;

  # Clang 4 (rightfully) thinks signed comparisons of pointers with NULL are nonsense
  prePatch = ''
    substituteInPlace lib/wx/c_src/wxe_impl.cpp --replace 'temp > NULL' 'temp != NULL'

    ${prePatch}
  '';

  postPatch = ''
    patchShebangs make

    ${postPatch}
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
    ++ optional withSystemd "--enable-systemd"
    ++ optional stdenv.isDarwin "--enable-darwin-64bit"
    ++ configureFlags;

  # install-docs will generate and install manpages and html docs
  # (PDFs are generated only when fop is available).

  postInstall = ''
    ln -s $out/lib/erlang/lib/erl_interface*/bin/erl_call $out/bin/erl_call

    ${postInstall}
  '';

  # Some erlang bin/ scripts run sed and awk
  postFixup = ''
    wrapProgram $out/lib/erlang/bin/erl --prefix PATH ":" "${gnused}/bin/"
    wrapProgram $out/lib/erlang/bin/start_erl --prefix PATH ":" "${stdenv.lib.makeBinPath [ gnused gawk ]}"
  '';

  setupHook = ./setup-hook.sh;

  meta = with stdenv.lib; ({
    homepage = "https://www.erlang.org/";
    downloadPage = "https://www.erlang.org/download.html";
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
    maintainers = with maintainers; [ sjmackenzie couchemar gleber ];
    license = licenses.asl20;
  } // meta);
}
// optionalAttrs (preUnpack != "")      { inherit preUnpack; }
// optionalAttrs (postUnpack != "")     { inherit postUnpack; }
// optionalAttrs (patches != [])        { inherit patches; }
// optionalAttrs (patchPhase != "")     { inherit patchPhase; }
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
// optionalAttrs (installTargets != []) { inherit installTargets; }
// optionalAttrs (preInstall != "")     { inherit preInstall; }
// optionalAttrs (fixupPhase != "")     { inherit fixupPhase; }
// optionalAttrs (preFixup != "")       { inherit preFixup; }
// optionalAttrs (postFixup != "")      { inherit postFixup; }
)
