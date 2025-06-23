{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  prometheus-client,
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-prometheus";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-commons";
    repo = "django-prometheus";
    tag = "v${version}";
    hash = "sha256-cKkpsV3w2SUvQuSBm0MlTsomdrU4h7CS5L+nKFvrKA8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools >= 67.7.2, < 72.0.0" setuptools

    substituteInPlace setup.py \
      --replace-fail '"pytest-runner"' ""
  '';

  build-system = [ setuptools ];

  dependencies = [ prometheus-client ];

  pythonImportsCheck = [ "django_prometheus" ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/django-commons/django-prometheus/releases/tag/v${version}";
    description = "Django middlewares to monitor your application with Prometheus.io";
    homepage = "https://github.com/django-commons/django-prometheus";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
