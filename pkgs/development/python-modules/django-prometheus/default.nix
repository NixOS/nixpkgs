{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  prometheus-client,
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-prometheus";
  version = "2.3.1";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "korfuri";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JiLH+4mmNdb9BN81J5YFiMPna/3gaKUK6ARjmCa3fE8=";
  };

  patches = [ ./drop-untestable-database-backends.patch ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
  '';

  propagatedBuildInputs = [ prometheus-client ];

  pythonImportsCheck = [ "django_prometheus" ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/korfuri/django-prometheus/releases/tag/v${version}";
    description = "Django middlewares to monitor your application with Prometheus.io";
    homepage = "https://github.com/korfuri/django-prometheus";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
