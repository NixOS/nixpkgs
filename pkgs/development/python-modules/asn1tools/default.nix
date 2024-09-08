{
  lib,
  bitstruct,
  buildPythonPackage,
  diskcache,
  fetchFromGitHub,
  prompt-toolkit,
  pyparsing,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "asn1tools";
  version = "0.166.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "eerimoq";
    repo = "asn1tools";
    rev = "refs/tags/${version}";
    hash = "sha256-TWAOML6nsLX3TYqoQ9fcSjrUmC4byXOfczfkmSaSa0k=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    bitstruct
    pyparsing
  ];

  passthru.optional-depdendencies = {
    shell = [ prompt-toolkit ];
    cache = [ diskcache ];
  };

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-depdendencies);

  pythonImportsCheck = [ "asn1tools" ];

  disabledTests = [
    # assert exact error message of pyparsing which changed and no longer matches
    # https://github.com/eerimoq/asn1tools/issues/167
    "test_parse_error"
  ];

  meta = with lib; {
    description = "ASN.1 parsing, encoding and decoding";
    mainProgram = "asn1tools";
    homepage = "https://github.com/eerimoq/asn1tools";
    changelog = "https://github.com/eerimoq/asn1tools/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
