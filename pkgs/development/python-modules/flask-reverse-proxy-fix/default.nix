{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, flask
, werkzeug
}:

buildPythonPackage rec {
  pname = "flask-reverse-proxy-fix";
  version = "0.2.1";

  # master fixes flask import syntax and has no major changes
  # new release requested: https://github.com/sublee/flask-silk/pull/6
  src = fetchFromGitHub {
    owner = "antarctica";
    repo = "flask-reverse-proxy-fix";
    rev = "v${version}";
    sha256 = "1jbr67cmnryn0igv05qkvqjwrwj2rsajvvjnv3cdkm9bkgb4h5k5";
  };

  disabled = !isPy3k;

  postPatch = ''
    sed -i 's@werkzeug.contrib.fixers@werkzeug.middleware.proxy_fix@g' flask_reverse_proxy_fix/middleware/__init__.py
  '';

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
