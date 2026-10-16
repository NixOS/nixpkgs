{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  libpcap,
  pkgconfig,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pcapy-ng";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stamparm";
    repo = "pcapy-ng";
    tag = finalAttrs.version;
    hash = "sha256-7Bm+cEK2cAvsRO1v9m3iwdt0kx0bz0YKSpCd4p3JsYk=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    cython
    pkgconfig
  ];

  buildInputs = [ libpcap ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    cd tests
  '';

  pythonImportsCheck = [ "pcapy" ];

  doCheck = false;

  enabledTestPaths = [ "pcapytests.py" ];

  meta = {
    description = "Module to interface with the libpcap packet capture library";
    homepage = "https://github.com/stamparm/pcapy-ng/";
    changelog = "https://github.com/stamparm/pcapy-ng/releases/tag/finalAttrs.src.tag";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
})
