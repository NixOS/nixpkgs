{ lib, buildPythonPackage, fetchFromGitHub, isPy3k, attrs, protobuf, zeroconf }:

buildPythonPackage rec {
  pname = "aioesphomeapi";
  version = "2.6.4";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "esphome";
    repo = pname;
    rev = "v${version}";
    sha256 = "02x7y3d50d496885qqqg8hhhb2qdl1lbbr1jg49666saz6c4z0yn";
  };

  propagatedBuildInputs = [ attrs protobuf zeroconf ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "aioesphomeapi" ];

  meta = with lib; {
    description = "Python Client for ESPHome native API";
    homepage = "https://github.com/esphome/aioesphomeapi";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
