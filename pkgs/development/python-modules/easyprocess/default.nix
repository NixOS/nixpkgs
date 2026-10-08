{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  pytest-timeout,
  pyvirtualdisplay,
  imagemagick,
  inetutils,
  xvfb,
}:

buildPythonPackage (finalAtrrs: {
  pname = "easyprocess";
  version = "1.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "EasyProcess";
    inherit (finalAtrrs) version;
    hash = "sha256-iFiYMCpXqrlIlz6LXTKkIpOSufstmGqx1P/VkOW6kOw=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-timeout
    (pyvirtualdisplay.overridePythonAttrs { doCheck = false; }) # avoid reference loop
    imagemagick
    inetutils
    xvfb
  ];

  disabledTests = [
    "test_deadlock_pipe" # hangs, https://github.com/ponty/EasyProcess/issues/24
  ];

  meta = {
    description = "Easy to use python subprocess interface";
    homepage = "https://github.com/ponty/EasyProcess";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ layus ];
  };
})
