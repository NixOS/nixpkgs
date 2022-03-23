{ lib
, buildPythonPackage
, fetchPypi
, lxml
, python
}:

buildPythonPackage rec {
  pname = "jxmlease";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17l3w3ak07p72s8kv8hg0ilxs0kkxjn7bfwnl3g2cw58v1siab31";
  };

  propagatedBuildInputs = [
    lxml
  ];

  # tests broken in expat bump
  # https://github.com/Juniper/jxmlease/issues/26
  doCheck = false;

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m unittest discover -v
    runHook postCheck
  '';

  meta = with lib; {
    description = "Converts between XML and intelligent Python data structures";
    homepage = "https://github.com/Juniper/jxmlease";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
