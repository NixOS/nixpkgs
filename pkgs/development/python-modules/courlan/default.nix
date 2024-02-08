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

  # nixify path to the courlan binary in the test suite
  postPatch = ''
    substituteInPlace tests/unit_tests.py \
      --replace "\"courlan --help\"" "\"$out/bin/courlan --help\"" \
      --replace "courlan_bin = \"courlan\"" "courlan_bin = \"$out/bin/courlan\""
  '';

  pythonImportsCheck = [ "courlan" ];

  meta = with lib; {
    description = "Clean, filter and sample URLs to optimize data collection";
    homepage = "https://github.com/adbar/courlan";
    changelog = "https://github.com/adbar/courlan/blob/v${version}/HISTORY.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jokatzke ];
  };
}
