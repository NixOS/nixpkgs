{ lib, buildPythonPackage, fetchFromGitHub, isPy3k, attrs, protobuf, zeroconf }:

buildPythonPackage rec {
  pname = "aioesphomeapi";
  version = "2.6.3";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "esphome";
    repo = pname;
    rev = "v${version}";
    sha256 = "1lbjxqdx63fc7qxx7xwq4b9dafmdafj7p1ggs48hyhbqfwkrv9p7";
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
