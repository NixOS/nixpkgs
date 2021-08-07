{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pytest-runner
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "awkward0";
  version = "0.15.5";

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "awkward-0.x";
    rev = version;
    sha256 = "039pxzgll2yz8xpr6bw788ymvgvqgna5kgl9m6d9mzi4yhbjsjpx";
  };

  nativeBuildInputs = [ pytest-runner ];

  propagatedBuildInputs = [ numpy ];

  checkInputs = [ pytestCheckHook ];

  # Can't find a fixture
  disabledTests = [ "test_import_pandas" ];

  pythonImportsCheck = [ "awkward0" ];

  meta = with lib; {
    description = "Manipulate jagged, chunky, and/or bitmasked arrays as easily as Numpy";
    homepage = "https://github.com/scikit-hep/awkward-array";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc SuperSandro2000 ];
  };
}
