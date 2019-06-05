{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, llvm
, typesentry
, blessed
, pytest
}:

buildPythonPackage rec {
  pname = "datatable";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1s8z81zffrckvdwrrl0pkjc7gsdvjxw59xgg6ck81dl7gkh5grjk";
  };

  disabled = pythonOlder "3.5";

  propagatedBuildInputs = [ typesentry blessed ];
  buildInputs = [ llvm ];
  checkInputs = [ pytest ];

  LLVM = llvm;

  checkPhase = ''
    # py.test adds local datatable to path, which doesn't contain built native library.
    mv datatable datatable.hidden
    pytest
  '';

  meta = with lib; {
    description = "data.table for Python";
    homepage = "https://github.com/h2oai/datatable";
    license = licenses.mpl20;
    maintainers = with maintainers; [ abbradar ];
  };
}
