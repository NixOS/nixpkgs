{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchPypi,
  pytest7CheckHook,
  requests,
  requests-mock,
}:

buildPythonPackage rec {
  pname = "favicon";
  version = "0.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bWtaeN4qDQCEWJ9ofzhLLs1qZScJP+xWRAOxowYF16g=";
  };

  postPatch = ''
    sed -i "/pytest-runner/d" setup.py
  '';

  propagatedBuildInputs = [
    beautifulsoup4
    requests
  ];

  nativeCheckInputs = [
    pytest7CheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "favicon" ];

  meta = {
    description = "Find a website's favicon";
    homepage = "https://github.com/scottwernervt/favicon";
    changelog = "https://github.com/scottwernervt/favicon/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
  };
}
