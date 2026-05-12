{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  jsonschema,
  networkx,
  numpy,
  scipy,
  watchdog,

  pytestCheckHook,
  pytest-mock,
}:

buildPythonPackage (finalAttrs: {
  pname = "compas";
  version = "2.15.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "compas-dev";
    repo = "compas";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HnHD/CZNdRU5v2hTPctBBfVUJ5cEWOw1+4YwtkVAkFw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jsonschema
    networkx
    numpy
    scipy
    watchdog
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  disabledTestPaths = [
    # tests fetching and parsing network resources
    "tests/compas/files/test_xml.py::test_xml_from_url"
    "tests/compas/test_iotools.py::test_open_file_url_image"
    "tests/compas/test_iotools.py::test_open_file_url_text"
  ];

  meta = {
    description = "Computational framework for research and collaboration in Architecture, Engineering, Fabrication and Construction";
    homepage = "https://github.com/compas-dev/compas";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tetov ];
  };
})
