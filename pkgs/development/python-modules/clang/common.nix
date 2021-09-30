{ buildPythonPackage
, fetchPypi
, lib
, nose
, sha256
, version
}:

buildPythonPackage rec {
  inherit version;
  pname = "clang";

  src = fetchPypi {
    inherit pname sha256 version;
  };

  checkInputs = [ nose ];

  meta = with lib; {
    description = "Libclang Python bindings";
    homepage    = "https://clang.llvm.org/";
    license     = licenses.ncsa;
    maintainers = with maintainers; [ samuela ];
  };
}
