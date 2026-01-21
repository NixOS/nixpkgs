{
  lib,
  stdenv,
  buildPythonPackage,
  python,
  runCommand,
  fetchFromGitHub,
  configargparse,
  acme,
  configobj,
  cryptography,
  distro,
  josepy,
  parsedatetime,
  pyrfc3339,
  setuptools,
  dialog,
  gnureadline,
  pytest-xdist,
  pytestCheckHook,
  python-dateutil,
  writeShellScriptBin,
}:

buildPythonPackage rec {
  pname = "certbot";
  version = "5.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "certbot";
    repo = "certbot";
    tag = "v${version}";
    hash = "sha256-+LQX845Qw/T+kR846bNu9xTJ0zcL76rtp48e/Cgu6Vk=";
  };

  postPatch = "cd certbot"; # using sourceRoot would interfere with patches

  build-system = [ setuptools ];

  dependencies = [
    configargparse
    acme
    configobj
    cryptography
    distro
    josepy
    parsedatetime
    pyrfc3339
  ];

  buildInputs = [
    dialog
    gnureadline
  ];

  nativeCheckInputs = [
    python-dateutil
    pytestCheckHook
    pytest-xdist
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (writeShellScriptBin "sw_vers" ''
      echo 'ProductVersion: 13.0'
    '')
  ];

  pytestFlags = [
    "-pno:cacheprovider"
    "-Wignore::DeprecationWarning"
  ];

  disabledTests = [
    # network access
    "test_lock_order"
  ];

  __darwinAllowLocalNetworking = true;

  makeWrapperArgs = [ "--prefix PATH : ${dialog}/bin" ];

  # certbot.withPlugins has a similar calling convention as python*.withPackages
  # it gets invoked with a lambda, and invokes that lambda with the python package set matching certbot's:
  # certbot.withPlugins (cp: [ cp.certbot-dns-foo ])
  passthru.withPlugins =
    f:
    let
      pythonEnv = python.withPackages f;
    in
    runCommand "certbot-with-plugins" { } ''
      mkdir -p $out/bin
      cd $out/bin
      ln -s ${pythonEnv}/bin/certbot
    '';

  meta = {
    homepage = "https://github.com/certbot/certbot";
    changelog = "https://github.com/certbot/certbot/blob/${src.tag}/certbot/CHANGELOG.md";
    description = "ACME client that can obtain certs and extensibly update server configurations";
    platforms = lib.platforms.unix;
    mainProgram = "certbot";
    maintainers = [ ];
    license = with lib.licenses; [ asl20 ];
  };
}
