{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "packet-python";
  version = "1.44.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WVfMELOoml7Hx78jy6TAwlFRLuSQu9dtsb6Khs6/cgI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
  '';

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [
    "packet"
  ];

  meta = with lib; {
    description = "Python client for the Packet API";
    homepage = "https://github.com/packethost/packet-python";
    changelog = "https://github.com/packethost/packet-python/blob/v${version}/CHANGELOG.md";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ dipinhora ];
  };
}
