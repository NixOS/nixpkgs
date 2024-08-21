{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  mock,
  netaddr,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyeapi";
  version = "1.0.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "arista-eosplus";
    repo = "pyeapi";
    rev = "refs/tags/v.${version}";
    hash = "sha256-KDtL+ed9t9QoHVSVR2RQ+1Pll6CJuPrCamNem3keZRo=";
  };

  patches = [
    # Replace imp, https://github.com/arista-eosplus/pyeapi/pull/295
    (fetchpatch {
      name = "replace-imp.patch";
      url = "https://github.com/arista-eosplus/pyeapi/commit/1f2d8e1fa61566082ccb11a1a17e0f3d8a0c89df.patch";
      hash = "sha256-ONviRU6eUUZ+TTJ4F41ZXqavW7RIi1MBO7s7OsnWknk=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ netaddr ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pytestFlagsArray = [ "test/unit" ];

  pythonImportsCheck = [ "pyeapi" ];

  meta = with lib; {
    description = "Client for Arista eAPI";
    homepage = "https://github.com/arista-eosplus/pyeapi";
    changelog = "https://github.com/arista-eosplus/pyeapi/releases/tag/v.${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ astro ];
  };
}
