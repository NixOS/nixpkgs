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
  pyopenssl,
  pytz,
  requests,
  six,
  zope-component,
  zope-interface,
  setuptools,
  dialog,
  gnureadline,
  pytest-xdist,
  pytestCheckHook,
  python-dateutil,
}:

buildPythonPackage rec {
  pname = "certbot";
  version = "2.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "certbot";
    repo = "certbot";
    rev = "refs/tags/v${version}";
    hash = "sha256-yYB9Y0wniRgzNk5XatkjKayIPj7ienXsqOboKPwzIfk=";
  };

  sourceRoot = "${src.name}/${pname}";

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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

  pytestFlagsArray = [ "-o cache_dir=$(mktemp -d)" ];

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
    changelog = "https://github.com/certbot/certbot/blob/${src.rev}/certbot/CHANGELOG.md";
    description = "ACME client that can obtain certs and extensibly update server configurations";
    platforms = platforms.unix;
    mainProgram = "certbot";
    maintainers = with maintainers; [ domenkozar ];
    license = with licenses; [ asl20 ];
  };
}
