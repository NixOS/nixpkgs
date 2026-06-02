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
  setuptools,
}:

buildPythonPackage rec {
  pname = "readme-renderer";
  version = "44.0";
  pyproject = true;

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
    (fetchpatch2 {
      name = "docutils-0.22-compat.patch";
      url = "https://github.com/pypa/readme_renderer/commit/d047a29755a204afca8873a6ecf30e686ccf6a27.patch";
      hash = "sha256-GHTfRuOZr5c4mwu4s8K5IpvG1ZP1o/qd0U4H09BzhE8=";
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

  meta = {
    description = "Python library for rendering readme descriptions";
    homepage = "https://github.com/pypa/readme_renderer";
    changelog = "https://github.com/pypa/readme_renderer/releases/tag/${version}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
