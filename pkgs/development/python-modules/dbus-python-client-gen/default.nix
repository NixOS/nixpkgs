{ lib
, buildPythonPackage
, fetchFromGitHub
, into-dbus-python
, dbus-python
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dbus-python-client-gen";
  version = "0.8.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "stratis-storage";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-RYgS4RNLLCtp+5gS/LlzdH7rlub48TSSSKhykkkBcuo=";
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
    changelog = "https://github.com/stratis-storage/dbus-python-client-gen/blob/v${version}/CHANGES.txt";
    license = licenses.mpl20;
    maintainers = with maintainers; [ nickcao ];
  };
}
