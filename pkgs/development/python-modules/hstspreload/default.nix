{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
}:

buildPythonPackage rec {
  pname = "hstspreload";
  version = "2021.9.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "sethmlarson";
    repo = pname;
    rev = version;
    sha256 = "sha256-CZlXnRe4yA6VJF48t73m2PbBRFzg0XTgT7J1N83Ojc4=";
  };

  # tests require network connection
  doCheck = false;

  pythonImportsCheck = [ "hstspreload" ];

  meta = with lib; {
    description = "Chromium HSTS Preload list as a Python package and updated daily";
    homepage = "https://github.com/sethmlarson/hstspreload";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc SuperSandro2000 ];
  };
}
