{ lib
, aiohttp
, xmltodict
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "omnilogic";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "djtimca";
    repo = "omnilogic-api";
    rev = version;
    sha256 = "081awb0fl40b5ighc9yxfq1xkgxz7l5dvz5544hx965q2r20wvsg";
  };

  propagatedBuildInputs = [
    aiohttp
    xmltodict
  ];

  postPatch = ''
    # Is not used but still present in setup.py
    substituteInPlace setup.py --replace "'config'," ""
  '';

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "omnilogic" ];

  meta = with lib; {
    description = "Python interface for the Hayward Omnilogic pool control system";
    homepage = "https://github.com/djtimca/omnilogic-api";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
