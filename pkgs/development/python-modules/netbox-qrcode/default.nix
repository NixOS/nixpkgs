{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, pillow
, qrcode
, netbox
}:

buildPythonPackage rec {
  pname = "netbox-qrcode";
  version = "0.0.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = "netbox-qrcode";
    rev = "v${version}";
    hash = "sha256-vED+B+GYIgThhyG3dS+rT68yRE4kiMaBOiB8jsUKLiY=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    qrcode
    pillow
  ];

  checkInputs = [
    netbox
  ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  pythonImportsCheck = [
    "netbox_qrcode"
  ];

  meta = with lib; {
    description = "NetBox Plugin for generate QR Codes";
    homepage = "https://github.com/netbox-community/netbox-qrcode";
    license = licenses.asl20;
    maintainers = with maintainers; [ sinavir ];
  };
}
