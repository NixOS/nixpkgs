{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  requests,
  requests-toolbelt,
}:

buildPythonPackage rec {
  pname = "aws-request-signer";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "aws_request_signer";
    hash = "sha256-DVorDO0wz94Fhduax7VsQZ5B5SnBfsHQoLoW4m6Ce+U=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "poetry>=0.12" poetry-core \
      --replace-fail poetry.masonry.api poetry.core.masonry.api
  '';

  build-system = [ poetry-core ];

  dependencies = [
    requests
    requests-toolbelt
  ];

  doCheck = false;

  meta = {
    changelog = "https://github.com/iksteen/aws-request-signer/releases/tag/${version}";
    description = "Python library to sign AWS requests using AWS Signature V4";
    homepage = "https://github.com/iksteen/aws-request-signer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
