{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "identify";
  version = "1.5.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "969d844b7a85d32a5f9ac4e163df6e846d73c87c8b75847494ee8f4bd2186421";
  };

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "File identification library for Python";
    homepage = "https://github.com/chriskuehl/identify";
    license = licenses.mit;
  };
}
