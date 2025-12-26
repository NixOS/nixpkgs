{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  setuptools,
  flask,
  webassets,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flask-assets";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "miracle2k";
    repo = "flask-assets";
    tag = version;
    hash = "sha256-R6cFTT+r/i5j5/QQ+cCFmeuO7SNTiV1F+e0JTxwIUGY=";
  };

  patches = [
    # On master branch but not in a release.
    (fetchpatch2 {
      name = "refactor-with-pytest.patch";
      url = "https://github.com/miracle2k/flask-assets/commit/56e06dbb160c165e0289ac97496354786fe3f3fd.patch?full_index=1";
      hash = "sha256-Feo7gHHmHtWRB+3XvlECdU4i5rpyjyKEYEUCuy24rf4=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    flask
    webassets
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "flask_assets" ];

  meta = {
    homepage = "https://github.com/miracle2k/flask-assets";
    description = "Asset management for Flask, to compress and merge CSS and Javascript files";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
