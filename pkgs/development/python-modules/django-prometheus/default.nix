{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
  prometheus-client,
  psycopg,
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-prometheus";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-commons";
    repo = "django-prometheus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ghY8eznPbkK7/jaeTAG3v5CD4ZZbFNNWSfjBNfuHBTo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools >= 67.7.2, < 72.0.0" setuptools

    substituteInPlace setup.py \
      --replace-fail '"pytest-runner"' ""
  '';

  pythonRelaxDeps = [
    "django"
  ];

  build-system = [ setuptools ];

  dependencies = [
    django
    prometheus-client
  ];

  pythonImportsCheck = [ "django_prometheus" ];

  nativeCheckInputs = [
    psycopg
    pytestCheckHook
    pytest-django
  ];

  meta = {
    changelog = "https://github.com/django-commons/django-prometheus/releases/tag/${finalAttrs.src.tag}";
    description = "Django middlewares to monitor your application with Prometheus.io";
    homepage = "https://github.com/django-commons/django-prometheus";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
