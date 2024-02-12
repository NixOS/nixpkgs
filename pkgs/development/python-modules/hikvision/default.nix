{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "hikvision";
  version = "2.0.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "fbradyirl";
    repo = pname;
    rev = "v${version}";
    sha256 = "1l0zvir4hf1pcwwcmrhkspbdljzmi4lknxar5bkipdanpsm588mn";
  };

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "hikvision.api" ];

  meta = with lib; {
    description = "Python module for interacting with Hikvision IP Cameras";
    homepage = "https://github.com/fbradyirl/hikvision";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
