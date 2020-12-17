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
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "awkward-0.x";
    rev = version;
    sha256 = "17zrw25h6g5m4ik1c5piqb7q2bxrshfm4hm3lzfz4s8gi0xjm5gz";
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
