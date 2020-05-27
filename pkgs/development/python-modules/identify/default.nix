{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "identify";
  version = "1.4.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1w6vy3nk28xhnamnmh7ddawprmb1ri2yw5s9lphmpq2hpfbqvh93";
  };

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "File identification library for Python";
    homepage = "https://github.com/chriskuehl/identify";
    license = licenses.mit;
  };
}
