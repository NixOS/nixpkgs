{
  lib,
  buildPythonPackage,
  fetchPypi,
  stdenv,

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
  ]
  ++ lib.concatAttrValues optional-dependencies;

  preCheck = ''
    # necessary on darwin to pass the testsuite
    export LANG=en_US.UTF-8
  '';

  # Cairo tries to load system fonts by default.
  # It's surfaced as a Cairo "out of memory" error in tests.
  __impureHostDeps = [ "/System/Library/Fonts" ];

  postCheck = ''
    export LANG=${if stdenv.hostPlatform.isDarwin then "en_US.UTF-8" else "C.UTF-8"}
  '';

  meta = {
    description = "Module for dynamic SVG charting";
    homepage = "http://www.pygal.org";
    changelog = "https://github.com/Kozea/pygal/blob/${version}/docs/changelog.rst";
    downloadPage = "https://github.com/Kozea/pygal";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
    mainProgram = "pygal_gen.py";
  };
}
