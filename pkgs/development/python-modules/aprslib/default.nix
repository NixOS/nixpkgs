{ lib
, buildPythonPackage
, fetchFromGitHub
, mox3
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aprslib";
  version = "0.6.47";

  src = fetchFromGitHub {
    owner = "rossengeorgiev";
    repo = "aprs-python";
    rev = "v${version}";
    sha256 = "1569v74ym2r8vxx3dnjcs5fr7rdrfb0i9sycny5frw2zgms4ag6b";
  };

  checkInputs = [
    mox3
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aprslib" ];

  meta = with lib; {
    description = "Module for accessing APRS-IS and parsing APRS packets";
    homepage = "https://github.com/rossengeorgiev/aprs-python";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
