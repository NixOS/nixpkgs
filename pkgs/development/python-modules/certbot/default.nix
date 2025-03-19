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
  pytz,
  setuptools,
  dialog,
  gnureadline,
  pytest-xdist,
  pytestCheckHook,
  python-dateutil,
}:

buildPythonPackage rec {
  pname = "certbot";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "certbot";
    repo = "certbot";
    tag = "v${version}";
    hash = "sha256-lYGJgUNDzX+bE64GJ+djdKR+DXmhpcNbFJrAEnP86yQ=";
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
    pytz
    setuptools # for pkg_resources
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

  pytestFlagsArray = [
    "-p no:cacheprovider"
    "-W"
    "ignore::DeprecationWarning"
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
    # AttributeError: module 'josepy' has no attribute 'ComparableX509'
    broken = lib.versionAtLeast josepy.version "2";
    homepage = "https://github.com/certbot/certbot";
    changelog = "https://github.com/certbot/certbot/blob/${src.tag}/certbot/CHANGELOG.md";
    description = "ACME client that can obtain certs and extensibly update server configurations";
    platforms = platforms.unix;
    mainProgram = "certbot";
    maintainers = with maintainers; [ domenkozar ];
    license = with licenses; [ asl20 ];
  };
}
