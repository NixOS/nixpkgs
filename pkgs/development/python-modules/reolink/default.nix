{ lib
, aiohttp
, aiounittest
, buildPythonPackage
, fetchFromGitHub
, ffmpeg-python
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "reolink";
  version = "0053";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fwestenberg";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qjp7n2qa9n9fdhfcgfgw89hy19z5144cxhkhmhv1xnfdiz175qd";
  };

  propagatedBuildInputs = [
    aiohttp
    ffmpeg-python
    requests
  ];

  checkInputs = [
    aiounittest
    pytestCheckHook
  ];

  postPatch = ''
    # Packages in nixpkgs is different than the module name
    substituteInPlace setup.py \
      --replace "ffmpeg" "ffmpeg-python"
  '';

  # https://github.com/fwestenberg/reolink/issues/83
  doCheck = false;

  pytestFlagsArray = [
    "test.py"
  ];

  disabledTests = [
    # Tests require network access
    "test1_settings"
    "test2_states"
    "test3_images"
    "test4_properties"
    "test_succes"
  ];

  pythonImportsCheck = [
    "reolink"
  ];

  meta = with lib; {
    description = "Python module to interact with the Reolink IP camera API";
    homepage = "https://github.com/fwestenberg/reolink";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
