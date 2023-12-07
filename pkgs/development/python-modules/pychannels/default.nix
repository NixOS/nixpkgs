{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  pname = "pychannels";
  version = "1.2.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "fancybits";
    repo = pname;
    rev = version;
    hash = "sha256-E+VL4mJ2KxS5bJZc3Va+wvyVjT55LJz+1wHkxDRa85s=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has not published tests yet
  doCheck = false;
  pythonImportsCheck = [ "pychannels" ];

  meta = with lib; {
    description = "Python library for interacting with the Channels app";
    homepage = "https://github.com/fancybits/pychannels";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
