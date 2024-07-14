{
  lib,
  buildPythonPackage,
  fetchPypi,
  lxml,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "jxmlease";
  version = "1.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YSwVddiocCbeoJa7dazscwLdaQQPoj2RFuceMNXgg54=";
  };

  propagatedBuildInputs = [ lxml ];

  # tests broken in expat bump
  # https://github.com/Juniper/jxmlease/issues/26
  doCheck = false;

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "-v" ];

  meta = with lib; {
    description = "Converts between XML and intelligent Python data structures";
    homepage = "https://github.com/Juniper/jxmlease";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
