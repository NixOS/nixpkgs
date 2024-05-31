{
  lib,
  babel,
  buildPythonPackage,
  fetchPypi,
  langcodes,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  tld,
  urllib3,
}:

buildPythonPackage rec {
  pname = "courlan";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1wZoQzTxi+StofvVfyaArfADZkj22ECFL3pIItOt/Y0=";
  };

  # Tests try to write to /tmp directly. use $TMPDIR instead.
  postPatch = ''
    substituteInPlace tests/unit_tests.py \
      --replace-fail "\"courlan --help\"" "\"$out/bin/courlan --help\"" \
      --replace-fail "courlan_bin = \"courlan\"" "courlan_bin = \"$out/bin/courlan\"" \
      --replace-fail "/tmp" "$TMPDIR"
  '';

  build-system = [ setuptools ];

  dependencies = [
    babel
    langcodes
    tld
    urllib3
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # disable tests that require an internet connection
  disabledTests = [ "test_urlcheck" ];

  pythonImportsCheck = [ "courlan" ];

  meta = with lib; {
    description = "Clean, filter and sample URLs to optimize data collection";
    homepage = "https://github.com/adbar/courlan";
    changelog = "https://github.com/adbar/courlan/blob/v${version}/HISTORY.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ jokatzke ];
    mainProgram = "courlan";
  };
}
