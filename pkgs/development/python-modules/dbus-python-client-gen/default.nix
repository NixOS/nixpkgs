{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  into-dbus-python,
  dbus-python,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "dbus-python-client-gen";
  version = "0.8.4";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "stratis-storage";
    repo = "dbus-python-client-gen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nmF6fdUgr7ACK7Pvy3ikc0Xjzfh6iTYNLc+rAf9I9Mg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    into-dbus-python
    dbus-python
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dbus_python_client_gen" ];

  meta = {
    description = "Python library for generating dbus-python client code";
    homepage = "https://github.com/stratis-storage/dbus-python-client-gen";
    changelog = "https://github.com/stratis-storage/dbus-python-client-gen/blob/v${finalAttrs.version}/CHANGES.txt";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
