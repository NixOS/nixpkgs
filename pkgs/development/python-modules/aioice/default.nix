{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, attrs
, dnspython
, netifaces
, ifaddr
}:
buildPythonPackage rec {
  pname = "aioice";
  version = "0.9.0";
  pyproject = true;
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/CQBscS24ZNy6q6qKP0b2cv2sOQS5IYlKXxTtJXuvR4=";
  };
  nativeBuildInputs = [ setuptools ];
  propagatedBuildInputs = [
    attrs
    dnspython
    netifaces
    ifaddr
  ];
  pythonImportsCheck = [ "aioice" ];
  meta = {
    description = "An ICE (Interactive Connectivity Establishment) library for asyncio";
    homepage = "https://github.com/aiortc/aioice";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sdubey ];
  };
}