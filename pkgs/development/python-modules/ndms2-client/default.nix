{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ndms2-client";
  version = "0.1.2";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "foxel";
    repo = "python_ndms2_client";
    rev = version;
    hash = "sha256-cM36xNLymg5Xph3bvbUGdAEmMABJ9y3/w/U8re6ZfB4=";
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
