{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
}:

buildPythonPackage rec {
  pname = "hstspreload";
  version = "2021.4.26";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "sethmlarson";
    repo = pname;
    rev = version;
    sha256 = "sha256-bjyOsZIsYE3xF2/imp+4HPOZzh5wIehAru/uqfijleE=";
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
