{
  lib,
  buildPythonPackage,
  fetchpatch,
  fetchPypi,
  attrs,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyqwikswitch";
  version = "0.94";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IpyWz+3EMr0I+xULBJJhBgdnQHNPJIM1SqKFLpszhQc=";
  };

  patches = [
    # https://github.com/kellerza/pyqwikswitch/pull/7
    (fetchpatch {
      name = "replace-async-timeout-with-asyncio.timeout.patch";
      url = "https://github.com/kellerza/pyqwikswitch/commit/7b3f2211962b30bb6beea9a4fe17cd04cdf8e27f.patch";
      hash = "sha256-sdO5jzIgKdneNY5dTngIzUFtyRg7HBGaZA1BBeAJxu4=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    attrs
    requests
  ];

  pythonImportsCheck = [
    "pyqwikswitch"
    "pyqwikswitch.threaded"
  ];

  doCheck = false; # no tests in sdist

  meta = with lib; {
    description = "QwikSwitch USB Modem API binding for Python";
    homepage = "https://github.com/kellerza/pyqwikswitch";
    license = licenses.mit;
    teams = [ teams.home-assistant ];
  };
}
