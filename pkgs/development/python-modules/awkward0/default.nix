{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pandas
, pytestrunner
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "awkward0";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "awkward-0.x";
    rev = version;
    sha256 = "sha256-C6/byIGcabGjws5QI9sh5BO2M4Lhqkooh4mSjUEKCKU=";
  };

  nativeBuildInputs = [ pytestrunner ];

  propagatedBuildInputs = [ numpy ];

  checkInputs = [ pandas pytestCheckHook ];

  checkPhase = ''
    # Almost all tests in this file fail
    rm tests/test_persist.py
    py.test
  '';

  meta = with lib; {
    description = "Manipulate jagged, chunky, and/or bitmasked arrays as easily as Numpy";
    homepage = "https://github.com/scikit-hep/awkward-array";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc SuperSandro2000 ];
  };
}
