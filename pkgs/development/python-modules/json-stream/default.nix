{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  iconv,
  pytestCheckHook,
  requests,
  json-stream-rs-tokenizer,
  setuptools,
}:

buildPythonPackage rec {
  pname = "json-stream";
  version = "2.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "daggaz";
    repo = "json-stream";
    tag = "v${version}";
    hash = "sha256-oZYVRgDSl15/UJmhTAoLk3UoVimQeLGNOjNXLH6GTtY=";
  };

  build-system = [ setuptools ];

  dependencies = [ json-stream-rs-tokenizer ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ iconv ];

  optional-dependencies = {
    httpx = [ httpx ];
    requests = [ requests ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "json_stream" ];

  disabledTests = [ "test_writer" ];

  meta = with lib; {
    description = "Streaming JSON parser";
    homepage = "https://github.com/daggaz/json-stream";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
