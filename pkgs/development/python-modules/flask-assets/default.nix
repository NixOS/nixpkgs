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
    rev = "refs/tags/${version}";
    hash = "sha256-R6cFTT+r/i5j5/QQ+cCFmeuO7SNTiV1F+e0JTxwIUGY=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/miracle2k/flask-assets/commit/56e06dbb160c165e0289ac97496354786fe3f3fd.patch?full_index=1";
      hash = "sha256-Feo7gHHmHtWRB+3XvlECdU4i5rpyjyKEYEUCuy24rf4=";
    })
  ];

  postPatch = ''
    substituteInPlace tests/test_integration.py \
      --replace-fail 'static_path=' 'static_url_path=' \
      --replace-fail "static_folder = '/'" "static_folder = '/x'" \
      --replace-fail "'/foo'" "'/x/foo'"
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    flask
    webassets
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "flask_assets" ];

  meta = with lib; {
    homepage = "https://github.com/miracle2k/flask-assets";
    description = "Asset management for Flask, to compress and merge CSS and Javascript files";
    license = licenses.bsd2;
    maintainers = with maintainers; [ abbradar ];
  };
}
