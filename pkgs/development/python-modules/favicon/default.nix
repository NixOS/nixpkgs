{ lib
, beautifulsoup4
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "favicon";
  version = "0.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

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
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [
    "favicon"
  ];

  meta = with lib; {
    description = "Find a website's favicon";
    homepage = "https://github.com/scottwernervt/favicon";
    changelog = "https://github.com/scottwernervt/favicon/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}
