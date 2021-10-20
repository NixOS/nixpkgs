{ lib, buildPythonPackage, fetchPypi, hypothesis, lark-parser, libcst, black, parso, pytestCheckHook, pytest-cov, pytest-xdist }:

buildPythonPackage rec {
  pname = "hypothesmith";
  version = "0.1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "039fd6aa0102f89df9df7ad4cff70aa8068678c13c3be2713c92568917317a04";
  };

  propagatedBuildInputs = [ hypothesis lark-parser libcst ];

  checkInputs = [ black parso pytestCheckHook pytest-cov pytest-xdist ];

  pythonImportsCheck = [ "hypothesmith" ];

  meta = with lib; {
    description = "Hypothesis strategies for generating Python programs, something like CSmith";
    homepage = "https://github.com/Zac-HD/hypothesmith";
    license = licenses.mpl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
