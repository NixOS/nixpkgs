{
  lib,
  buildPythonPackage,
  cmarkgfm,
  docutils,
  fetchPypi,
  fetchpatch2,
  nh3,
  pygments,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "readme-renderer";
  version = "44.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "readme_renderer";
    inherit version;
    hash = "sha256-hxIDTqu/poBcrPFAK07rKnMCj3LRFm1vXLf5wEfF0eE=";
  };

  patches = [
    # https://github.com/pypa/readme_renderer/pull/325
    (fetchpatch2 {
      name = "pygment-2_19-compatibility.patch";
      url = "https://github.com/pypa/readme_renderer/commit/04d5cfe76850192364eff344be7fe27730af8484.patch";
      hash = "sha256-QBU3zL3DB8gYYwtKrIC8+H8798pU9Sz3T9e/Q/dXksw=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    docutils
    nh3
    pygments
  ];

  optional-dependencies.md = [ cmarkgfm ];

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.md;

  disabledTests = [
    "test_rst_fixtures"
    "test_rst_008.rst"
  ];

  pythonImportsCheck = [ "readme_renderer" ];

  meta = with lib; {
    description = "Python library for rendering readme descriptions";
    homepage = "https://github.com/pypa/readme_renderer";
    changelog = "https://github.com/pypa/readme_renderer/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
