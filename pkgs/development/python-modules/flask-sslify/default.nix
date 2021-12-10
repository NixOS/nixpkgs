{ lib, fetchFromGitHub, buildPythonPackage, flask }:

buildPythonPackage rec {
  pname = "Flask-SSLify";
  version = "0.1.5";

  src = fetchFromGitHub {
     owner = "kennethreitz42";
     repo = "flask-sslify";
     rev = "v0.1.5";
     sha256 = "17rqdlwsmyzcxk6sp95spbxn9fjd93yjpl11afihvb8lfv8jmch2";
  };

  propagatedBuildInputs = [ flask ];

  doCheck = false;
  pythonImportsCheck = [ "flask_sslify" ];

  meta = with lib; {
    description = "A Flask extension that redirects all incoming requests to HTTPS";
    homepage = "https://github.com/kennethreitz42/flask-sslify";
    license = licenses.bsd2;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
