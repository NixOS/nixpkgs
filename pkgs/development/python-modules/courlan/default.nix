{ lib
, buildPythonPackage
, fetchPypi
, langcodes
, pytestCheckHook
, tld
, urllib3
, pythonOlder
}:

buildPythonPackage rec {
  pname = "courlan";
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PDVRHDZSXLL5Qc1nCbejp0LtlfC55WyX7sDBb9wDUYM=";
  };

  propagatedBuildInputs = [
    langcodes
    tld
    urllib3
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # disable tests that require an internet connection
  disabledTests = [
    "test_urlcheck"
  ];

  # tests try to write to /tmp directly. use $TMPDIR instead.
  postPatch = ''
    substituteInPlace tests/unit_tests.py \
      --replace "\"courlan --help\"" "\"$out/bin/courlan --help\"" \
      --replace "courlan_bin = \"courlan\"" "courlan_bin = \"$out/bin/courlan\"" \
      --replace "/tmp" "$TMPDIR"
  '';

  pythonImportsCheck = [ "courlan" ];

  meta = with lib; {
    description = "Clean, filter and sample URLs to optimize data collection";
    mainProgram = "courlan";
    homepage = "https://github.com/adbar/courlan";
    changelog = "https://github.com/adbar/courlan/blob/v${version}/HISTORY.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ jokatzke ];
  };
}
