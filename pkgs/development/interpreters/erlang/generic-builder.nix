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
  rev ? "OTP-${version}",
  src ? fetchFromGitHub {
    inherit rev sha256;
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
  preUnpack ? "",
  postUnpack ? "",
  patches ? [ ],
  patchPhase ? "",
  prePatch ? "",
  postPatch ? "",
  configureFlags ? [ ],
  configurePhase ? "",
  preConfigure ? "",
  postConfigure ? "",
  buildPhase ? "",
  preBuild ? "",
  postBuild ? "",
  installPhase ? "",
  preInstall ? "",
  postInstall ? "",
  checkPhase ? "",
  preCheck ? "",
  postCheck ? "",
  fixupPhase ? "",
  preFixup ? "",
  postFixup ? "",
  meta ? { },
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
    optionalAttrs
    optionalString
    ;
  wxPackages2 = if stdenv.hostPlatform.isDarwin then [ wxGTK ] else wxPackages;

  major = builtins.head (builtins.splitVersion version);
in
stdenv.mkDerivation (
  {
    # name is used instead of pname to
    # - not have to pass pnames as argument
    # - have a separate pname for erlang (main module)
    name =
      "${baseName}"
      + optionalString javacSupport "_javac"
      + optionalString odbcSupport "_odbc"
      + "-${version}";

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

    postPatch = ''
      patchShebangs make

      ${postPatch}
    ''
    + optionalString (lib.versionOlder "25" version) ''
      substituteInPlace lib/os_mon/src/disksup.erl \
        --replace-fail '"sh ' '"${runtimeShell} '
    '';

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
    ++ optional (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) "--disable-jit"
    ++ configureFlags;

    # install-docs will generate and install manpages and html docs
    # (PDFs are generated only when fop is available).
    installTargets = [
      "install"
      "install-docs"
    ];

    postInstall = ''
      ln -s $out/lib/erlang/lib/erl_interface*/bin/erl_call $out/bin/erl_call

      ${postInstall}
    '';

    # Some erlang bin/ scripts run sed and awk
    postFixup = ''
      wrapProgram $out/lib/erlang/bin/erl --prefix PATH ":" "${gnused}/bin/"
      wrapProgram $out/lib/erlang/bin/start_erl --prefix PATH ":" "${
        lib.makeBinPath [
          gnused
          gawk
        ]
      }"
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

    meta =
      with lib;
      (
        {
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
          teams = [ teams.beam ];
          license = licenses.asl20;
        }
        // meta
      );
  }
  // optionalAttrs (preUnpack != "") { inherit preUnpack; }
  // optionalAttrs (postUnpack != "") { inherit postUnpack; }
  // optionalAttrs (patches != [ ]) { inherit patches; }
  // optionalAttrs (prePatch != "") { inherit prePatch; }
  // optionalAttrs (patchPhase != "") { inherit patchPhase; }
  // optionalAttrs (configurePhase != "") { inherit configurePhase; }
  // optionalAttrs (preConfigure != "") { inherit preConfigure; }
  // optionalAttrs (postConfigure != "") { inherit postConfigure; }
  // optionalAttrs (buildPhase != "") { inherit buildPhase; }
  // optionalAttrs (preBuild != "") { inherit preBuild; }
  // optionalAttrs (postBuild != "") { inherit postBuild; }
  // optionalAttrs (checkPhase != "") { inherit checkPhase; }
  // optionalAttrs (preCheck != "") { inherit preCheck; }
  // optionalAttrs (postCheck != "") { inherit postCheck; }
  // optionalAttrs (installPhase != "") { inherit installPhase; }
  // optionalAttrs (preInstall != "") { inherit preInstall; }
  // optionalAttrs (fixupPhase != "") { inherit fixupPhase; }
  // optionalAttrs (preFixup != "") { inherit preFixup; }
  // optionalAttrs (postFixup != "") { inherit postFixup; }
)
