{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyfronius";
  version = "0.6.2";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nielstron";
    repo = pname;
    rev = "release-${version}";
    sha256 = "03szfgf2g0hs4r92p8jb8alzl7byzrirxsa25630zygmkadzgrz2";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
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
