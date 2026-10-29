{
  lib,
  fetchFromGitHub,
  fetchpatch,
  buildPythonPackage,
  setuptools,
  pyusb,
  pymodbus,
  pyserial-asyncio,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "python-dali";
  version = "0.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sde1000";
    repo = "python-dali";
    tag = "v${version}";
    hash = "sha256-F/D0wyMVCUaL2SCdPKvnGS22tSgDnvUh6rs2ToKON2c=";
  };

  patches = [
    # pymodbus 3.x support
    (fetchpatch {
      url = "https://github.com/sde1000/python-dali/commit/fe85b8fd9a746d16a03de8fd8c643ef4254d1ccd.patch";
      hash = "sha256-bcfr948g7M6m3AQVArcYw9a22jA5eMim+J58iKci55s=";
    })
  ];

  build-system = [ setuptools ];

  optional-dependencies = {
    driver-unipi = [
      pyusb
      pymodbus
    ];
    driver-serial = [ pyserial-asyncio ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "dali" ];

  meta = {
    description = "IEC 62386 (DALI) lighting control library";
    homepage = "https://github.com/sde1000/python-dali";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ sikmir ];
  };
}
