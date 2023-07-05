{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, flask
, python
}:

buildPythonPackage rec {
  pname = "flask-basicauth";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "jpvanhal";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-han0OjMI1XmuWKHGVpk+xZB+/+cpV1I+659zOG3hcPY=";
  };

  patches = [
    (fetchpatch {
      # The unit tests fail due to an invalid import:
      #   from flask.ext.basicauth import BasicAuth
      #
      # This patch replaces it with the correct import:
      #   from flask_basicauth import BasicAuth
      #
      # The patch uses the changes from this pull request,
      # and therefore can be removed once this pull request
      # has been merged:
      #   https://github.com/jpvanhal/flask-basicauth/pull/29
      name = "fix-test-flask-ext-imports.patch";
      url = "https://github.com/jpvanhal/flask-basicauth/commit/23f57dc1c3d85ea6fc7f468e8d8c6f19348a0a81.patch";
      hash = "sha256-njUYjO0TRe3vr5D0XjIfCNcsFlShbGxtFV/DJerAKDE=";
    })
  ];

  propagatedBuildInputs = [ flask ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m unittest discover
    runHook postCheck
  '';

  pythonImportsCheck = [ "flask_basicauth" ];

  meta = with lib; {
    homepage = "https://github.com/jpvanhal/flask-basicauth";
    description = "HTTP basic access authentication for Flask";
    license = licenses.mit;
    maintainers = with maintainers; [ wesnel ];
  };
}
