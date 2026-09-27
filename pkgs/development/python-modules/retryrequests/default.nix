{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
}:

buildPythonPackage rec {
  pname = "retryrequests";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = "retryrequests";
    tag = "v${version}";
    hash = "sha256-bla17VebkQlga6K+yGAd+XUxXz0Oh4Kem4i6tq29QxQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  pythonImportsCheck = [ "retryrequests" ];

  meta = {
    description = "Python library that extends requests to retry on failures";
    homepage = "https://github.com/thombashi/retryrequests";
    changelog = "https://github.com/thombashi/retryrequests/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yajo ];
  };
}
