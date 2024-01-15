{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "1.0.4";
  format = "setuptools";
  pname = "python-editor";

  src = fetchPypi {
    inherit pname version;
    sha256 = "51fda6bcc5ddbbb7063b2af7509e43bd84bfc32a4ff71349ec7847713882327b";
  };

  # No proper tests
  doCheck = false;

  meta = with lib; {
    description = "A library that provides the `editor` module for programmatically";
    homepage = "https://github.com/fmoo/python-editor";
    license = licenses.asl20;
  };
}
