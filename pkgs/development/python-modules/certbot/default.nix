{
  lib,
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
}:

buildPythonPackage rec {
  pname = "certbot";
  version = "5.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "certbot";
    repo = "certbot";
    tag = "v${version}";
    hash = "sha256-jKhdclLBeWv6IxIZQtD8VWbSQ3SDZePA/kTxjiBXJ4o=";
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
  ];

  pytestFlags = [
    "-pno:cacheprovider"
    "-Wignore::DeprecationWarning"
  ];

  disabledTests = [
    # network access
    "test_lock_order"
  ];

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

  meta = with lib; {
    homepage = "https://github.com/certbot/certbot";
    changelog = "https://github.com/certbot/certbot/blob/${src.tag}/certbot/CHANGELOG.md";
    description = "ACME client that can obtain certs and extensibly update server configurations";
    platforms = platforms.unix;
    mainProgram = "certbot";
    maintainers = [ ];
    license = with licenses; [ asl20 ];
  };
}
