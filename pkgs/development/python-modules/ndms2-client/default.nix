{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ndms2-client";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "foxel";
    repo = "python_ndms2_client";
    rev = version;
    sha256 = "1sc39d10hm1y8xf3gdqzq1akrx94k590l106242j9bvfqyr8lrk9";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ndms2_client" ];

  meta = with lib; {
    description = "Keenetic NDMS 2.x and 3.x client";
    homepage = "https://github.com/foxel/python_ndms2_client";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
