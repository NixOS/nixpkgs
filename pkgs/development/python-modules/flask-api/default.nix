{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  setuptools,

  # dependencies
  flask,

  # tests
  markdown,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flask-api";
  version = "3.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "flask-api";
    repo = "flask-api";
    rev = "refs/tags/v${version}";
    hash = "sha256-nHgeI5FLKkDp4uWO+0eaT4YSOMkeQ0wE3ffyJF+WzTM=";
  };

  patches = [
    (fetchpatch {
      # werkzeug 3.0 support
      url = "https://github.com/flask-api/flask-api/commit/9c998897f67d8aa959dc3005d7d22f36568b6938.patch";
      hash = "sha256-vaCZ4gVlfQXyeksA44ydkjz2FxODHt3gTTP+ukJwEGY=";
    })
  ];

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ flask ];

  nativeCheckInputs = [
    markdown
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/flask-api/flask-api";
    changelog = "https://github.com/flask-api/flask-api/releases/tag/v${version}";
    description = "Browsable web APIs for Flask";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nickcao ];
  };
}
