{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  flask,
  nose2,
}:

buildPythonPackage rec {
  pname = "flask-xml-rpc-re";
  version = "0.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Croydon";
    repo = "flask-xml-rpc-reloaded";
    tag = version;
    hash = "sha256-S+9Ur22ExgVjKMOKG19cBz2aCVdEyOoS7uoz17CDzd8=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    flask
  ];

  nativeCheckInputs = [
    nose2
  ];

  installCheckPhase = ''
    runHook preInstallCheck
    nose2 -v
    runHook postInstallCheck
  '';

  pythonImportsCheck = [ "flask_xmlrpcre" ];

  meta = {
    description = "Let your Flask apps provide XML-RPC APIs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      lukegb
    ];
    homepage = "https://github.com/Croydon/flask-xml-rpc-reloaded";
    changelog = "https://github.com/Croydon/flask-xml-rpc-reloaded/releases/tag/${version}";
  };
}
