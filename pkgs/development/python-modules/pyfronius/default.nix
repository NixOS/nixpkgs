{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyfronius";
  version = "0.7.1";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nielstron";
    repo = pname;
    rev = "release-${version}";
    sha256 = "1xwx0c1dp2374bwigzwhvcj4577vrxyhn6i5zv73k9ydc7w1xgyz";
  };

  patches = [
    (fetchpatch {
      # Python3.10 compatibility; https://github.com/nielstron/pyfronius/pull/7
      url = "https://github.com/nielstron/pyfronius/commit/9deb209d4246ff575cd3c4c5373037bf11df6719.patch";
      hash = "sha256-srXYCvp86kGYUYZIXMcu68hEbkTspD945J+hc/AhqSw=";
    })
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyfronius" ];

  meta = with lib; {
    description = "Python module to communicate with Fronius Symo";
    homepage = "https://github.com/nielstron/pyfronius";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
