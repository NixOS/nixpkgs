{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, vcrpy
}:

buildPythonPackage rec {
  pname = "pytest-vcr";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "ktosiek";
    repo = pname;
    rev = version;
    sha256 = "1i6fin91mklvbi8jzfiswvwf1m91f43smpj36a17xrzk4gisfs6i";
  };

  propagatedBuildInputs = [
    pytest
    vcrpy
   ];

  # Tests are using an obsolete attribute 'config'
  # https://github.com/ktosiek/pytest-vcr/issues/43
  doCheck = false;
  pythonImportsCheck = [ "pytest_vcr" ];

  meta = with lib; {
    description = "Integration VCR.py into pytest";
    homepage = "https://github.com/ktosiek/pytest-vcr";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
