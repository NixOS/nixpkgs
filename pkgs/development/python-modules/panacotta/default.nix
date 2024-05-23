{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "panacotta";
  version = "0.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "u1f35c";
    repo = "python-panacotta";
    rev = "panacotta-${version}";
    hash = "sha256-0Ygmj9iRWKvjAuy6j6HjGhl9qJJylfvT5+Uwj44jLgE=";
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "panacotta" ];

  meta = with lib; {
    description = "Python API for controlling Panasonic Blu-Ray players";
    homepage = "https://github.com/u1f35c/python-panacotta";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
