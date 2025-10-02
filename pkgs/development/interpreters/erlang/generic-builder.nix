{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  gawk,
  gnum4,
  gnused,
  libxml2,
  libxslt,
  ncurses,
  nix-update-script,
  openssl,
  perl,
  runtimeShell,
  openjdk11 ? null, # javacSupport
  unixODBC ? null, # odbcSupport
  libGL ? null,
  libGLU ? null,
  wxGTK ? null,
  xorg ? null,
  parallelBuild ? false,
  systemd,
  wxSupport ? true,
  # systemd support for epmd
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd,
  wrapGAppsHook3,
  zlib,
}:
{
  baseName ? "erlang",
  version,
  sha256 ? null,
  tag ? "OTP-${version}",
  src ? fetchFromGitHub {
    inherit tag sha256;
    owner = "erlang";
    repo = "otp";
  },
  enableHipe ? true,
  enableDebugInfo ? false,
  enableThreads ? true,
  enableSmpSupport ? true,
  enableKernelPoll ? true,
  javacSupport ? false,
  javacPackages ? [ openjdk11 ],
  odbcSupport ? false,
  odbcPackages ? [ unixODBC ],
  opensslPackage ? openssl,
  wxPackages ? [
    libGL
    libGLU
    wxGTK
    xorg.libX11
    wrapGAppsHook3
  ],
}:

assert
  wxSupport
  -> (
    if stdenv.hostPlatform.isDarwin then
      wxGTK != null
    else
      libGL != null && libGLU != null && wxGTK != null && xorg != null
  );

assert odbcSupport -> unixODBC != null;
assert javacSupport -> openjdk11 != null;

let
  inherit (lib)
    optional
    optionals
    optionalString
    ;
  wxPackages2 = if stdenv.hostPlatform.isDarwin then [ wxGTK ] else wxPackages;

  major = builtins.head (builtins.splitVersion version);
in
stdenv.mkDerivation {
  pname = "${baseName}" + optionalString javacSupport "_javac" + optionalString odbcSupport "_odbc";

  inherit src version;

  LANG = "C.UTF-8";

  nativeBuildInputs = [
    makeWrapper
    perl
    gnum4
    libxslt
    libxml2
  ];

  env = {
    # only build man pages and shell/IDE docs
    DOC_TARGETS = "man chunks";
  };

  buildInputs = [
    ncurses
    opensslPackage
    zlib
  ]
  ++ optionals wxSupport wxPackages2
  ++ optionals odbcSupport odbcPackages
  ++ optionals javacSupport javacPackages
  ++ optional systemdSupport systemd;

  debugInfo = enableDebugInfo;

  # On some machines, parallel build reliably crashes on `GEN    asn1ct_eval_ext.erl` step
  enableParallelBuilding = parallelBuild;

  configureFlags = [
    "--with-ssl=${lib.getOutput "out" opensslPackage}"
  ]
  ++ [ "--with-ssl-incl=${lib.getDev opensslPackage}" ] # This flag was introduced in R24
  ++ optional enableThreads "--enable-threads"
  ++ optional enableSmpSupport "--enable-smp-support"
  ++ optional enableKernelPoll "--enable-kernel-poll"
  ++ optional enableHipe "--enable-hipe"
  ++ optional javacSupport "--with-javac"
  ++ optional odbcSupport "--with-odbc=${unixODBC}"
  ++ optional wxSupport "--enable-wx"
  ++ optional systemdSupport "--enable-systemd"
  ++ optional stdenv.hostPlatform.isDarwin "--enable-darwin-64bit"
  # make[3]: *** [yecc.beam] Segmentation fault: 11
  ++ optional (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) "--disable-jit";

  installPhase = ''
    runHook preInstall

    make install
    make install-docs

    ln -sv $out/lib/erlang/lib/erl_interface*/bin/erl_call $out/bin/erl_call

    wrapProgram $out/lib/erlang/bin/erl --prefix PATH ":" "${gnused}/bin/"
    wrapProgram $out/lib/erlang/bin/start_erl --prefix PATH ":" "${
      lib.makeBinPath [
        gnused
        gawk
      ]
    }"

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "OTP-(${major}.*)"
        "--override-filename"
        "pkgs/development/interpreters/erlang/${major}.nix"
      ];
    };
  };

  meta = {
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

    platforms = lib.platforms.unix;
    teams = [ lib.teams.beam ];
    license = lib.licenses.asl20;
  };
}
