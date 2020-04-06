{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
}:

buildPythonPackage rec {
  pname = "hstspreload";
  version = "2020.3.31";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "sethmlarson";
    repo = pname;
    rev = version;
    sha256 = "12hncxzawvdsrssl350xxn1byfm1firgd3ziqfll4xhhw403jaa9";
  };

  # tests require network connection
  doCheck = false;

  meta = with lib; {
    description = "Chromium HSTS Preload list as a Python package and updated daily";
    homepage = "https://github.com/sethmlarson/hstspreload";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
