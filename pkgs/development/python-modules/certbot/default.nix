{ lib
, buildPythonPackage
, python
, runCommand
, fetchFromGitHub
, configargparse
, acme
, configobj
, cryptography
, distro
, josepy
, parsedatetime
, pyrfc3339
, pyopenssl
, pytz
, requests
, six
, zope-component
, zope-interface
, setuptools
, dialog
, gnureadline
, pytest-xdist
, pytestCheckHook
, python-dateutil
}:

buildPythonPackage rec {
  pname = "certbot";
  version = "2.7.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-BZ7JqAciwbmkpbzR/qZHAraLJWWXNRN3Er4XvfU5kYs=";
  };

  sourceRoot = "${src.name}/${pname}";

  propagatedBuildInputs = [
    configargparse
    acme
    configobj
    cryptography
    distro
    josepy
    parsedatetime
    pyrfc3339
    pyopenssl
    pytz
    requests
    six
    zope-component
    zope-interface
    setuptools # for pkg_resources
  ];

  buildInputs = [ dialog gnureadline ];

  nativeCheckInputs = [
    python-dateutil
    pytestCheckHook
    pytest-xdist
  ];

  pytestFlagsArray = [
    "-o cache_dir=$(mktemp -d)"
    # See https://github.com/certbot/certbot/issues/8746
    "-W ignore::ResourceWarning"
    "-W ignore::DeprecationWarning"
  ];

  doCheck = true;

  makeWrapperArgs = [ "--prefix PATH : ${dialog}/bin" ];

  # certbot.withPlugins has a similar calling convention as python*.withPackages
  # it gets invoked with a lambda, and invokes that lambda with the python package set matching certbot's:
  # certbot.withPlugins (cp: [ cp.certbot-dns-foo ])
  passthru.withPlugins = f:
    let
      pythonEnv = python.withPackages f;

    in
    runCommand "certbot-with-plugins"
      { } ''
      mkdir -p $out/bin
      cd $out/bin
      ln -s ${pythonEnv}/bin/certbot
    '';

  meta = with lib; {
    homepage = src.meta.homepage;
    description = "ACME client that can obtain certs and extensibly update server configurations";
    platforms = platforms.unix;
    maintainers = with maintainers; [ domenkozar ];
    license = with licenses; [ asl20 ];
  };
}
