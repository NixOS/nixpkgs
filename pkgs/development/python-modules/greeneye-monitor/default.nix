{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, siobrultech-protocols
}:

buildPythonPackage rec {
  pname = "greeneye-monitor";
  version = "4.0.1";

  disabled = pythonOlder "3.10";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jkeljo";
    repo = "greeneye-monitor";
    rev = "refs/tags/v${version}";
    hash = "sha256-S/1MT9ZQ9G0F1WXqzNKhVo8vtfPLzr8WRlfYc7TU9iQ=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "siobrultech_protocols==" "siobrultech_protocols>="
  '';

  propagatedBuildInputs = [
    aiohttp
    siobrultech-protocols
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "greeneye.monitor"
  ];

  meta = with lib; {
    description = "Receive data packets from GreenEye Monitor";
    homepage = "https://github.com/jkeljo/greeneye-monitor";
    changelog = "https://github.com/jkeljo/greeneye-monitor/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
