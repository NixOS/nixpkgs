{ buildPythonPackage
, fetchPypi
, lib
, python
, unittestCheckHook

, opencensus-context
, google-api-core
}:
buildPythonPackage rec {
  pname = "opencensus";
  version = "0.11.0";

  checkInputs = [ unittestCheckHook ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "026216abab89d94d850492f3dc65950055ec4f84115fa6c7beaffba44a346e42";
  };

  buildInputs = [
    opencensus-context
  ];

  propagatedBuildInputs = [
    google-api-core
  ];

  postInstall = ''
    ln -sf ${opencensus-context}/lib/${python.libPrefix}/site-packages/opencensus/common/runtime_context \
      $out/lib/${python.libPrefix}/site-packages/opencensus/common/
  '';

  meta = with lib; {
    description = "A stats collection and distributed tracing framework";
    homepage = "https://github.com/census-instrumentation/opencensus-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ billhuang ];
  };
}
