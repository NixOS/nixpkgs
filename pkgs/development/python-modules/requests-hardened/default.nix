{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  uv-build,
  requests,

  pproxy,
  pytest-socket,
  pysocks,
  trustme,
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "requests-hardened";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "saleor";
    repo = "requests-hardened";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IYHP2p5dHH8l232VVOsC3boWJYyyMI7PCuVzAlRSAh0=";
  };

  build-system = [ uv-build ];
  dependencies = [ requests ];

  nativeCheckInputs = [
    pproxy
    pytest-socket
    pysocks
    trustme
    pytestCheckHook
  ];

  pythonImportsCheck = [ "requests_hardened" ];

  meta = {
    description = "Library that adds hardened behavior to python requests";
    homepage = "https://github.com/saleor/requests-hardened";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.ryand56 ];
  };
})
