{ lib, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "deep_merge";
  version = "0.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "tUQV+Qk0xC4zQRTihky01OczWzStOW41rYYQyWBlpH4=";
  };

  nativeCheckInputs = [
    nose
  ];

  doCheck = false;

  meta = with lib; {
    description = "This library contains a simple utility for deep-merging dictionaries and the data structures they contain";
    homepage = "https://github.com/halfak/deep_merge";
    license = licenses.mit;
    maintainers = [ maintainers.anhdle14 ];
  };
}
