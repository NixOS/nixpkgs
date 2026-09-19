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

  stdenv,
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

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  disabledTests = [
    "test_open_file_url_image"
    "test_open_file_url_text"
    "test_xml_from_url"
  ]
  ++ lib.optionals (!stdenv.isDarwin) [
    "test_basic_rpc_call"
    "test_switch_package"
  ];

  dependencies = [
    jsonschema
    networkx
    numpy
    scipy
    watchdog
  ];

  meta = {
    description = "Computational framework for research and collaboration in Architecture, Engineering, Fabrication and Construction.";
    homepage = "https://github.com/compas-dev/compas";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tetov ];
  };
})
