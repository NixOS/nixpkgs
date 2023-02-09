{ lib
, buildPythonPackage
, fetchFromGitHub
, into-dbus-python
, dbus-python
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dbus-python-client-gen";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "stratis-storage";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nSzxT65WHBVct5pGHmIAHJXftd0tKZeK/argN+V9xcs=";
  };

  propagatedBuildInputs = [
    into-dbus-python
    dbus-python
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "dbus_python_client_gen" ];

  meta = with lib; {
    description = "A Python library for generating dbus-python client code";
    homepage = "https://github.com/stratis-storage/dbus-python-client-gen";
    license = licenses.mpl20;
    maintainers = with maintainers; [ nickcao ];
  };
}
