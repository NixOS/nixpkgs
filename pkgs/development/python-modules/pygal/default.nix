{
  lib,
  buildPythonPackage,
  fetchPypi,

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
  version = "3.0.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bF2jPxBB6LMMvJgPijSRDZ7cWEuDMkApj2ol32VCUok=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace pytest-runner ""
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ importlib-metadata ];

  passthru.optional-dependencies = {
    lxml = [ lxml ];
    png = [ cairosvg ];
  };

  nativeCheckInputs = [
    pyquery
    pytestCheckHook
  ] ++ passthru.optional-dependencies.png;

  preCheck = ''
    # necessary on darwin to pass the testsuite
    export LANG=en_US.UTF-8
  '';

  meta = with lib; {
    changelog = "https://github.com/Kozea/pygal/blob/${version}/docs/changelog.rst";
    downloadPage = "https://github.com/Kozea/pygal";
    description = "Sexy and simple python charting";
    mainProgram = "pygal_gen.py";
    homepage = "http://www.pygal.org";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
