{ buildPythonPackage
, fetchPypi
, lib
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "opencensus-context";
  version = "0.1.3";

  checkInputs = [ unittestCheckHook ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "a03108c3c10d8c80bb5ddf5c8a1f033161fa61972a9917f9b9b3a18517f0088c";
  };

  meta = with lib; {
    description = "Provide in-process context propagation";
    homepage = "https://github.com/census-instrumentation/opencensus-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ billhuang ];
  };
}
