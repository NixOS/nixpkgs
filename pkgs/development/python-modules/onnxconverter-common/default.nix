{ lib, buildPythonPackage, fetchPypi, protobuf, numpy, requests, onnx }:

buildPythonPackage rec {
  pname = "onnxconverter_common";
  version = "1.7.0";
  format = "wheel";
  
  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    sha256 = "1mgfxvcii4h6d7z2zbr5979aajhdblayfpaakm0vv9ka313i0dvd";
  };
    
  propagatedBuildInputs = [ protobuf numpy requests onnx ];

  meta = with lib; {
    homepage = "https://github.com/microsoft/onnxconverter-common/";
    description = "Functions and utilities for converting from variousAI frameworks to ONNX";
    license = licenses.mit;
    maintainers = with maintainers; [ imalsogreg ];
  };
}
