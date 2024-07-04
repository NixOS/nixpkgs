{
  lib,
  buildPythonPackage,
  deprecated,
  fetchFromGitHub,
  fetchpatch,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-mock,
}:

buildPythonPackage rec {
  pname = "openevsewifi";
  version = "1.1.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "miniconfig";
    repo = "python-openevse-wifi";
    rev = "v${version}";
    hash = "sha256-7+BC5WG0JoyHNjgsoJBQRVDpmdXMJCV4bMf6pIaS5qo=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    deprecated
    requests
  ];

  nativeCheckInputs = [
    requests-mock
    pytestCheckHook
  ];

  patches = [
    # Switch to poetry-core, https://github.com/miniconfig/python-openevse-wifi/pull/31
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/miniconfig/python-openevse-wifi/commit/1083868dd9f39a8ad7bb17f02cea1b8458e5b82d.patch";
      hash = "sha256-XGeyi/PchBju1ICgL/ZCDGCbWwIJmLAcHuKaj+kDsI0=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'pytest-cov = "^2.8.1"' ""
  '';

  pythonImportsCheck = [ "openevsewifi" ];

  meta = with lib; {
    description = "Module for communicating with the wifi module from OpenEVSE";
    homepage = "https://github.com/miniconfig/python-openevse-wifi";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
