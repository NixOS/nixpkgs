{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-memcached";
  version = "1.59";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "linsomniac";
    repo = "python-memcached";
    rev = version;
    hash = "sha256-tHqkwNloPTXOrEGtuDLu1cTw4SKJ4auv8UUbqdNp698=";
  };

  propagatedBuildInputs = [
    six
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  # all tests fail
  doCheck = false;

  pythonImportsCheck = [ "memcache" ];

  meta = with lib; {
    description = "Pure python memcached client";
    homepage = "https://github.com/linsomniac/python-memcached";
    license = licenses.psfl;
    maintainers = with maintainers; [ dotlambda ];
  };
}
