{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-cov
, pytestCheckHook
, requests
}:

buildPythonPackage rec {
  pname = "brottsplatskartan";
  version = "1.0.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "chrillux";
    repo = pname;
    rev = version;
    sha256 = "07iwmnchvpw156j23yfccg4c32izbwm8b02bjr1xgmcwzbq21ks9";
  };

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    pytest-cov
    pytestCheckHook
  ];

  pythonImportsCheck = [ "brottsplatskartan" ];

  meta = with lib; {
    description = "Python API wrapper for brottsplatskartan.se";
    homepage = "https://github.com/chrillux/brottsplatskartan";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
