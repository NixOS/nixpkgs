{ lib, buildPythonPackage, fetchPypi, hypothesis, lark, libcst, black, parso, pytestCheckHook, pytest-cov, pytest-xdist }:

buildPythonPackage rec {
  pname = "hypothesmith";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fb7b3fd03d76eddd4474b0561e1c2662457593a74cc300fd27e5409cd4d7922";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "lark-parser" "lark"
  '';

  propagatedBuildInputs = [ hypothesis lark libcst ];

  checkInputs = [ black parso pytestCheckHook pytest-cov pytest-xdist ];

  pytestFlagsArray = [ "-v" ];  # tests are fairly slow, prevents timeout due to no stdout printing
  pythonImportsCheck = [ "hypothesmith" ];

  meta = with lib; {
    description = "Hypothesis strategies for generating Python programs, something like CSmith";
    homepage = "https://github.com/Zac-HD/hypothesmith";
    license = licenses.mpl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
