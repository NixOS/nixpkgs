{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, flask-cors
, blaze-odo
, sqlalchemy
, psutil
}:

buildPythonPackage rec {
  pname = "blaze";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    hash = "sha256-c6DsSQqh3SmS5AMqzn6f4XBAU3IYj4kX9quiYlSyBhE=";
  };

  propagatedBuildInputs = [
    flask
    flask-cors
    blaze-odo
    sqlalchemy
    psutil
  ];

  # ImportError: cannot import name 'Iterator' from 'collections'
  # pythonImportsCheck = [ "blaze" ];
  doCheck = false;

  meta = with lib; {
    description = "NumPy and Pandas interface to big data";
    homepage = "https://github.com/blaze/blaze";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ Madouura ];
  };
}
