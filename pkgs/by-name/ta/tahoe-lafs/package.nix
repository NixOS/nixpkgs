{
  lib,
  python3Packages,
  fetchFromGitHub,
  texinfo,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "tahoe-lafs";
  version = "1.20.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tahoe-lafs";
    repo = "tahoe-lafs";
    tag = "tahoe-lafs-${version}";
    hash = "sha256-9qaL4GmdjClviKTnwAxaTywvJChQ5cVVgWs1IkFxhIY=";
  };

  outputs = [
    "out"
    "doc"
    "info"
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

  nativeBuildInputs = with python3Packages; [
    # docs
    recommonmark
    sphinx
    sphinx-rtd-theme
    texinfo
  ];

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
      future
      klein
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
  versionCheckProgram = "${placeholder "out"}/bin/tahoe";
  versionCheckProgramArg = "--version";

  checkPhase = ''
    runHook preCheck

    runHook versionCheckHook
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
      "TGPPLv1+"
    ];
    maintainers = with lib.maintainers; [ MostAwesomeDude ];
    platforms = lib.platforms.linux;
  };
}
