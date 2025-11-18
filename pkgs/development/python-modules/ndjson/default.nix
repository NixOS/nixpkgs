{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  six,
  watchdog,
}:

buildPythonPackage rec {
  pname = "ndjson";
  version = "0.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v5dGy2uxy1PRcs2n8VTAfHhtZl/yg0Hk5om3lrIp5dY=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner', " ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
    six
    watchdog
  ];

  pythonImportsCheck = [ "ndjson" ];

  meta = with lib; {
    description = "Module supports ndjson";
    homepage = "https://github.com/rhgrant10/ndjson";
    changelog = "https://github.com/rhgrant10/ndjson/blob/v${version}/HISTORY.rst";
    license = licenses.gpl3Only;
    maintainers = [ ];
  };
}
