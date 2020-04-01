{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
}:

buildPythonPackage rec {
  pname = "hstspreload";
  version = "2020.2.29";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "sethmlarson";
    repo = pname;
    rev = version;
    sha256 = "1s6f9sdr5l9dqri92s8qr7r1nyvai3vnpcaw06293kc8dribi0m2";
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
