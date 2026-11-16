{
  buildPythonPackage,
  hatchling,
  httpx,
  httpx2,
  nab,
  nab-provider,
  packaging,
  truststore,
  typing-extensions,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "nab-index";
  inherit (nab) src version;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/nab-index";

  build-system = [ hatchling ];

  dependencies = [
    nab-provider
    packaging
    truststore
    typing-extensions
    urllib3
  ];

  optional-dependencies = {
    httpx = [ httpx ] ++ httpx.optional-dependencies.http2;
    httpx2 = [ httpx2 ] ++ httpx2.optional-dependencies.http2;
  };

  # The `nab` package runs this package's tests.
  doCheck = false;
  passthru.tests = { inherit nab; };

  pythonImportsCheck = [ "nab_index" ];

  meta = {
    description = "PyPI Simple API client and on-disk cache for nab";
    inherit (nab.meta)
      homepage
      changelog
      license
      maintainers
      ;
  };
})
