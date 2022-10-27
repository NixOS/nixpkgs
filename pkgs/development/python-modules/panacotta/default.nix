{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "panacotta";
  version = "0.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "u1f35c";
    repo = "python-panacotta";
    rev = "panacotta-${version}";
    sha256 = "0v2fa18n50iy18n22klkgjral728iplj6yk3b6hjkzas5dk9wd9c";
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "panacotta"
  ];

  meta = with lib; {
    description = "Python API for controlling Panasonic Blu-Ray players";
    homepage = "https://github.com/u1f35c/python-panacotta";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
