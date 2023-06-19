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
  pname = "reolink-aio";
  version = "0.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "starkillerOG";
    repo = "reolink_aio";
    rev = "refs/tags/${version}";
    hash = "sha256-4+gJcW5wi1MH3OskcfWyDNaT4FKJO5boHaxdORZUwPs=";
  };

  postPatch = ''
    # Packages in nixpkgs is different than the module name
    substituteInPlace setup.py \
      --replace "ffmpeg" "ffmpeg-python"
  '';
  propagatedBuildInputs = [
    aiohttp
    ffmpeg-python
    requests
  ];

  doCheck = false; # all testse require a network device

  nativeCheckInputs = [
    aiounittest
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests/test.py"
  ];

  disabledTests = [
    # Tests require network access
    "test1_settings"
    "test2_states"
    "test3_images"
    "test4_properties"
    "test_succes"
    "test_wrong_host"
    "test_wrong_password"
    "test_wrong_user"
  ];

  pythonImportsCheck = [
    "reolink_aio"
  ];

  meta = with lib; {
    description = "Module to interact with the Reolink IP camera API";
    homepage = "https://github.com/starkillerOG/reolink_aio";
    changelog = "https://github.com/starkillerOG/reolink_aio/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
