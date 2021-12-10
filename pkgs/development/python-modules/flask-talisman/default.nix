{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "flask-talisman";
  version = "0.8.1";

  src = fetchFromGitHub {
     owner = "wntrblm";
     repo = "flask-talisman";
     rev = "v0.8.1";
     sha256 = "0rjdi73aq7idgig0whsidqf5qc3bjhf5d7qv4kh9f3jhwjnd5mqs";
  };

  buildInputs = [
    flask
  ];

  propagatedBuildInputs = [
    six
  ];

  nativeBuildInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "HTTP security headers for Flask";
    homepage = "https://github.com/wntrblm/flask-talisman";
    license = licenses.asl20;
    maintainers = [ lib.maintainers.symphorien ];
  };
}
