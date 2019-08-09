{ lib, buildPythonPackage, fetchPypi, isPy3k, attrs, protobuf, zeroconf }:

buildPythonPackage rec {
  pname = "aioesphomeapi";
  version = "2.0.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "db09e34dfc148279f303481c7da94b84c9b1442a41794f039c31253e81a58ffb";
  };

  propagatedBuildInputs = [ attrs protobuf zeroconf ];

  # no tests implemented
  doCheck = false;

  meta = with lib; {
    description = "Python Client for ESPHome native API";
    homepage = https://github.com/esphome/aioesphomeapi;
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];

    # Home Assistant should pin protobuf to the correct version. Can be tested using
    #     nix-build -E "with import ./. {}; home-assistant.override { extraPackages = ps: [ ps.aioesphomeapi ]; }"
    broken = !lib.hasPrefix "3.6.1" protobuf.version;
  };
}
