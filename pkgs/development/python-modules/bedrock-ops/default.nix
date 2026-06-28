{
  lib,
  boto3,
  botocore,
  buildPythonPackage,
  fetchurl,
  pythonOlder,
  uv-build,
}:

buildPythonPackage rec {
  pname = "bedrock-ops";
  version = "0.1.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchurl {
    url = "https://github.com/MukundaKatta/bedrock-ops/releases/download/v${version}/bedrock_ops-${version}.tar.gz";
    hash = "sha256-DT7hBt3GM1/XL6o8BUMXOqTxbR0MNGBt9zpdPfzrMEY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.11.7,<0.12.0" uv_build
  '';

  build-system = [ uv-build ];

  dependencies = [
    boto3
    botocore
  ];

  pythonImportsCheck = [ "bedrock_ops" ];

  # Tests require boto3 mocking with moto and live AWS-shape fixtures; the
  # upstream tests exist but are not part of the sdist. Skip CheckHook;
  # rely on pythonImportsCheck.
  doCheck = false;

  meta = {
    description = "Production-grade boto3 toolkit for AWS Bedrock with typed retry, capability lookup, and PII-safe Guardrails";
    homepage = "https://github.com/MukundaKatta/bedrock-ops";
    changelog = "https://github.com/MukundaKatta/bedrock-ops/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mukundakatta ];
  };
}
