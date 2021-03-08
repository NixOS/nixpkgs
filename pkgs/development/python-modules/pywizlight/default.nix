{ lib
, buildPythonPackage
, fetchFromGitHub
, asyncio-dgram
, click
}:

buildPythonPackage rec {
  pname = "pywizlight";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "sbidy";
    repo = pname;
    rev = "v${version}";
    sha256 = "0kyhyda28zbni9sjv6kvky6wlhqldl47niddgpbjsv5dlb9xvxns";
  };

  propagatedBuildInputs = [
    asyncio-dgram
    click
  ];

  # no tests are present
  doCheck = false;
  pythonImportsCheck = [ "pywizlight" ];

  meta = with lib; {
    description = "Python connector for WiZ light bulbs";
    homepage = "https://github.com/sbidy/pywizlight";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
