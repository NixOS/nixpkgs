{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  flask,
  packaging,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "flask-cors";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "corydolphin";
    repo = "flask-cors";
    rev = "refs/tags/${version}";
    hash = "sha256-o//ulROKKBv/CBJIGPBFP/+T0TpMHUVjr23Y5g1V05g=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ flask ];

  nativeCheckInputs = [
    pytestCheckHook
    packaging
  ];

  meta = with lib; {
    description = "Flask extension adding a decorator for CORS support";
    homepage = "https://github.com/corydolphin/flask-cors";
    changelog = "https://github.com/corydolphin/flask-cors/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ nickcao ];
  };
}
