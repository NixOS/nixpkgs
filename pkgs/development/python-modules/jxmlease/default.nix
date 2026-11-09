{
  lib,
  buildPythonPackage,
  fetchPypi,
  lxml,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "jxmlease";
  version = "1.0.3";
  format = "setuptools";

  src = fetchPypi {
    pname = "jxmlease";
    inherit (finalAttrs) version;
    hash = "sha256-YSwVddiocCbeoJa7dazscwLdaQQPoj2RFuceMNXgg54=";
  };

  propagatedBuildInputs = [ lxml ];

  # tests broken in expat bump
  # https://github.com/Juniper/jxmlease/issues/26
  doCheck = false;

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlags = [ "-v" ];

  meta = {
    description = "Converts between XML and intelligent Python data structures";
    homepage = "https://github.com/Juniper/jxmlease";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
