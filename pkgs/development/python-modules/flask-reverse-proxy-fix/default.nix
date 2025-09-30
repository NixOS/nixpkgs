{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  werkzeug,
}:

buildPythonPackage rec {
  pname = "flask-reverse-proxy-fix";
  version = "0.2.1";
  format = "setuptools";

  # master fixes flask import syntax and has no major changes
  # new release requested: https://github.com/sublee/flask-silk/pull/6
  src = fetchFromGitHub {
    owner = "antarctica";
    repo = "flask-reverse-proxy-fix";
    rev = "v${version}";
    hash = "sha256-ZRZI1psr1dnY2FbuLZXOQvLMJd4TF7BfBNZnW9kxeck=";
  };

  postPatch = ''
    sed -i 's@werkzeug.contrib.fixers@werkzeug.middleware.proxy_fix@g' flask_reverse_proxy_fix/middleware/__init__.py
  '';

  # This is needed so that setup.py does not add "devNone" to the version,
  # after which setuptools throws an error for an invalid version.
  env.CI_COMMIT_TAG = "v${version}";

  propagatedBuildInputs = [
    flask
    werkzeug
  ];

  meta = with lib; {
    description = "Python Flask middleware for applications running under a reverse proxy";
    maintainers = with maintainers; [ matthiasbeyer ];
    homepage = "https://github.com/antarctica/flask-reverse-proxy-fix";

    license = {
      fullName = "Open Government Licence";
      url = "http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/";
    };
  };
}
