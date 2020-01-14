{ lib, buildPythonPackage, fetchPypi, isPy3k, attrs, protobuf, zeroconf }:

buildPythonPackage rec {
  pname = "aioesphomeapi";
  version = "2.6.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "139d1d348fcfe2f34926a210a32dff069935d17167c4e1cb66e8b039cbb4d6c1";
  };

  propagatedBuildInputs = [ attrs protobuf zeroconf ];

  # no tests implemented
  doCheck = false;

  meta = with lib; {
    description = "Python Client for ESPHome native API";
    homepage = "https://github.com/esphome/aioesphomeapi";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];

    # Home Assistant should pin protobuf to the correct version. Can be tested using
    #     nix-build -E "with import ./. {}; home-assistant.override { extraPackages = ps: [ ps.aioesphomeapi ]; }"
    broken = !lib.hasPrefix "3.6.1" protobuf.version;
  };
}
