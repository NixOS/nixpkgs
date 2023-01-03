{ buildPythonPackage
, fetchPypi
, lib
, python
, unittestCheckHook
, google-api-core
}:

let
  opencensus-context = buildPythonPackage rec {
    pname = "opencensus-context";
    version = "0.1.3";

    checkInputs = [ unittestCheckHook ];

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-oDEIw8ENjIC7Xd9cih8DMWH6YZcqmRf5ubOhhRfwCIw=";
    };
  };
in
buildPythonPackage rec {
  pname = "opencensus";
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-AmIWq6uJ2U2FBJLz3GWVAFXsT4QRX6bHvq/7pEo0bkI=";
  };

  buildInputs = [
    # opencensus-context is embedded in opencensus
    opencensus-context
  ];

  propagatedBuildInputs = [
    google-api-core
  ];

  postInstall = ''
    ln -sf ${opencensus-context}/${python.sitePackages}/opencensus/common/runtime_context \
      $out/${python.sitePackages}/opencensus/common/
  '';

  checkInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "opencensus" ];

  meta = with lib; {
    description = "A stats collection and distributed tracing framework";
    homepage = "https://github.com/census-instrumentation/opencensus-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ billhuang ];
  };
}
