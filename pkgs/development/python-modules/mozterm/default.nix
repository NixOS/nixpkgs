{ lib, buildPythonPackage, fetchPypi, isPy3k, six }:

buildPythonPackage rec {
  pname = "mozterm";
  version = "1.0.0";

  # name 'unicode' is not defined
  disabled = isPy3k;

  propagatedBuildInputs = [six];

  src = fetchPypi {
    inherit pname version;
    sha256 = "b1e91acec188de07c704dbb7b0100a7be5c1e06567b3beb67f6ea11d00a483a4";
  };

  meta = with lib; {
    description = "Terminal abstractions built around the blessings module";
    license = licenses.mpl20;
  };
}
