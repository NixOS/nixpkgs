{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, aiohttp
, siobrultech-protocols
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "greeneye-monitor";
  version = "3.0.3";

  disabled = pythonOlder "3.5";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jkeljo";
    repo = "greeneye-monitor";
    rev = "v${version}";
    hash = "sha256-weZTOVFBlB6TxFs8pLWfyB7WD/bn3ljBjX2tVi1Zc/I=";
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

  pythonImportsCheck = [ "greeneye.monitor" ];

  meta = {
    description = "Receive data packets from GreenEye Monitor";
    homepage = "https://github.com/jkeljo/greeneye-monitor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
