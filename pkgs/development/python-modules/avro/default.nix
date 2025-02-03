{
  lib,
  buildPythonPackage,
  pythonOlder,
  setuptools,
  fetchPypi,
  typing-extensions,
  pytest7CheckHook,
}:

buildPythonPackage rec {
  pname = "avro";
  version = "1.11.3";
  pyproject = true;

  # distutils usage: https://github.com/search?q=repo%3Aapache%2Favro%20distutils&type=code
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-M5O7UTn5zweR0gV1bOHjmltYWGr1sVPWo7WhmWEOnRc=";
  };

  postPatch = lib.optionalString (!pythonOlder "3.12") ''
    substituteInPlace avro/test/test_tether_word_count.py \
      --replace-fail 'distutils' 'setuptools._distutils'
  '';

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [ typing-extensions ];

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytest7CheckHook ];

  disabledTests = [
    # Requires network access
    "test_server_with_path"
    # AssertionError: 'reader type: null not compatible with writer type: int'
    "test_schema_compatibility_type_mismatch"
  ];

  pythonImportsCheck = [ "avro" ];

  meta = with lib; {
    description = "Python serialization and RPC framework";
    mainProgram = "avro";
    homepage = "https://github.com/apache/avro";
    changelog = "https://github.com/apache/avro/releases/tag/release-${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ zimbatm ];
  };
}
