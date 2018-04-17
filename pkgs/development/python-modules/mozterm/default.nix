{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "mozterm";
  version = "0.1.0";

  # name 'unicode' is not defined
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4ebf8bd772d97c0f557184173f0f96cfca0abfc07e1ae975fbcfa76be50b5561";
  };

  meta = with lib; {
    description = "Terminal abstractions built around the blessings module";
    license = licenses.mpl20;
  };
}
