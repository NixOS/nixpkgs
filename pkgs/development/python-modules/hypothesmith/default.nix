{ lib, buildPythonPackage, fetchPypi, hypothesis, lark-parser, libcst, black, parso, pytestCheckHook, pytest-cov, pytest-xdist }:

buildPythonPackage rec {
  pname = "hypothesmith";
  version = "0.1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+f8EexXE7TEs49pX6idXD4bWtTzhKvnyXlnmV2oAQQo=";
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
