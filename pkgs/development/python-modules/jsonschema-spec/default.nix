{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build
  poetry-core,

  # propagates
  pathable,
  pyyaml,
  referencing,
  requests,

  # tests
  pytestCheckHook,
  pytest-cov-stub,
  responses,
}:

buildPythonPackage rec {
  pname = "jsonschema-spec";
  version = "0.3.4";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = "jsonschema-spec";
    tag = version;
    hash = "sha256-rCepDnVAOEsokKjWCuqDYbGIq6/wn4rsQRx5dXTUsYo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'referencing = ">=0.28.0,<0.30.0"' 'referencing = ">=0.28.0"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  pythonRelaxDeps = [ "referencing" ];

  propagatedBuildInputs = [
    pathable
    pyyaml
    referencing
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    responses
  ];

  passthru.skipBulkUpdate = true; # newer versions under the jsonschema-path name

  meta = with lib; {
    changelog = "https://github.com/p1c2u/jsonschema-spec/releases/tag/${version}";
    description = "JSONSchema Spec with object-oriented paths";
    homepage = "https://github.com/p1c2u/jsonschema-spec";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
