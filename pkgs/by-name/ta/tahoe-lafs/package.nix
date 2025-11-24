{
  lib,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
  texinfo,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "tahoe-lafs";
  version = "1.20.0-unstable-2025-10-12";
  pyproject = true;

  # workaround required to build an unstable version
  # TODO: when moving to a tagged version, remove this and the workaround for versionCheckHook
  env.SETUPTOOLS_SCM_PRETEND_VERSION = builtins.elemAt (builtins.split "-" version) 0;

  src = fetchFromGitHub {
    owner = "tahoe-lafs";
    repo = "tahoe-lafs";
    rev = "7b96d16aba511fd34dcc0c14c9db754229e19531";
    hash = "sha256-7qMeyL0j0D6Yos7qDhhplinKPV87Vu72dbE4eWql/g4=";
  };

  outputs = [
    "out"
    "doc"
    "info"
    "man"
  ];

  # Remove broken and expensive tests.
  preConfigure = ''
    (
      cd src/allmydata/test

      # Buggy?
      rm cli/test_create.py

      # These require Tor and I2P.
      rm test_connections.py test_iputil.py test_hung_server.py test_i2p_provider.py test_tor_provider.py
    )
  '';

  build-system = with python3Packages; [
    hatch-vcs
    hatchling
  ];

  nativeBuildInputs = # docs
  [
    installShellFiles
    texinfo
  ]
  ++ (with python3Packages; [
    recommonmark
    sphinx
    sphinx-rtd-theme
  ]);

  dependencies =
    with python3Packages;
    [
      attrs
      autobahn
      cbor2
      click
      collections-extended
      cryptography
      distro
      eliot
      filelock
      foolscap
      klein
      legacy-cgi
      magic-wormhole
      netifaces
      psutil
      pycddl
      pyopenssl
      pyrsistent
      pyutil
      pyyaml
      six
      treq
      twisted
      werkzeug
      zfec
      zope-interface
    ]
    ++ twisted.optional-dependencies.tls
    ++ twisted.optional-dependencies.conch;

  # Install the documentation.
  postInstall = ''
    (
      cd docs

      make singlehtml
      mkdir -p "$doc/share/doc/${pname}-${version}"
      cp -rv _build/singlehtml/* "$doc/share/doc/${pname}-${version}"

      make info
      mkdir -p "$info/share/info"
      cp -rv _build/texinfo/*.info "$info/share/info"

      installManPage man/man*/*
    )
  '';

  nativeCheckInputs =
    with python3Packages;
    [
      beautifulsoup4
      fixtures
      html5lib
      hypothesis
      mock
      prometheus-client
      testtools
      twisted
    ]
    ++ [
      versionCheckHook
    ];

  versionCheckProgramArg = "--version";

  checkPhase = ''
    runHook preCheck

    version=$SETUPTOOLS_SCM_PRETEND_VERSION runHook versionCheckHook
    trial --rterrors allmydata

    runHook postCheck
  '';

  meta = {
    description = "Tahoe-LAFS, a decentralized, fault-tolerant, distributed storage system";
    mainProgram = "tahoe";
    longDescription = ''
      Tahoe-LAFS is a secure, decentralized, fault-tolerant filesystem.
      This filesystem is encrypted and spread over multiple peers in
      such a way that it remains available even when some of the peers
      are unavailable, malfunctioning, or malicious.
    '';
    homepage = "https://tahoe-lafs.org/";
    license = [
      lib.licenses.gpl2Plus # or
      {
        fullName = "Transitive Grace Period Public Licence version 1.0";
        url = "https://github.com/tahoe-lafs/tahoe-lafs/blob/master/COPYING.TGPPL.rst";
      }
    ];
    maintainers = with lib.maintainers; [ MostAwesomeDude ];
    platforms = lib.platforms.linux;
  };
}
