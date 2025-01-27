{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  iconv,
  pytestCheckHook,
  pythonOlder,
  requests,
  json-stream-rs-tokenizer,
  setuptools,
}:

buildPythonPackage rec {
  pname = "json-stream";
  version = "2.3.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "daggaz";
    repo = "json-stream";
    tag = "v${version}";
    hash = "sha256-/GDEC/Poy84TGuXM34OW4+K/qMJELFfO+lNQ5M5VsdI=";
  };

  nativeBuildInputs = [ setuptools ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ iconv ];

  propagatedBuildInputs = [
    requests
    json-stream-rs-tokenizer
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "json_stream" ];

  disabledTests = [ "test_writer" ];

  meta = with lib; {
    description = "Streaming JSON parser";
    homepage = "https://github.com/daggaz/json-stream";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
