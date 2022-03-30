{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "metar";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "python-metar";
    repo = "python-metar";
    rev = "v${version}";
    sha256 = "sha256-pl2NWRfFCYyM2qvBt4Ic3wgbGkYZvAO6pX2Set8zYW8=";
  };

  patches = [
    (fetchpatch {
      # Fix flapping test; https://github.com/python-metar/python-metar/issues/161
      url = "https://github.com/python-metar/python-metar/commit/716fa76682e6c2936643d1cf62e3d302ef29aedd.patch";
      sha256 = "sha256-y82NN+KDryOiH+eG+2ycXCO9lqQLsah4+YpGn6lM2As=";
    })
    (fetchpatch {
      # Fix failing test: https://github.com/python-metar/python-metar/issues/165
      url = "https://github.com/python-metar/python-metar/commit/a4f9a4764b99bb0313876366d30728169db2770b.patch";
      sha256 = "sha256-sURHUb4gCKVMqEWFklTsxF0kr0SxC02Yr0287rZIvC0=";
    })
  ];

  checkInputs = [ pytestCheckHook ];

  disabledTests = [
    # https://github.com/python-metar/python-metar/issues/165
    "test_033_parseTime_auto_month"
  ];

  pythonImportsCheck = [ "metar" ];

  meta = with lib; {
    description = "Python parser for coded METAR weather reports";
    homepage = "https://github.com/python-metar/python-metar";
    license = with licenses; [ bsd1 ];
    maintainers = with maintainers; [ fab ];
  };
}
