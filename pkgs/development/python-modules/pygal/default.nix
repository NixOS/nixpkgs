{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  importlib-metadata,

  # optional-dependencies
  lxml,
  cairosvg,

  # tests
  pyquery,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pygal";
  version = "3.0.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wKDzTlvBwBl1wr+4NCrVIeKTrULlJWmd0AxNelLBS3E=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail pytest-runner ""
  '';

  build-system = [ setuptools ];

  dependencies = [ importlib-metadata ];

  optional-dependencies = {
    lxml = [ lxml ];
    png = [ cairosvg ];
  };

  nativeCheckInputs = [
    pyquery
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  preCheck = ''
    # necessary on darwin to pass the testsuite
    export LANG=en_US.UTF-8
  '';

  meta = with lib; {
    description = "Module for dynamic SVG charting";
    homepage = "http://www.pygal.org";
    changelog = "https://github.com/Kozea/pygal/blob/${version}/docs/changelog.rst";
    downloadPage = "https://github.com/Kozea/pygal";
    license = licenses.lgpl3Plus;
    maintainers = [ ];
    mainProgram = "pygal_gen.py";
  };
}
