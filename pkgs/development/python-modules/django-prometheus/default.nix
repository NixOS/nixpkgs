{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, prometheus-client
, psycopg2
, pytest-django
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "django-prometheus";
  version = "2.1.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "korfuri";
    repo = pname;
    rev = version;
    sha256 = "1y1cmycc545xrys41jk8kia36hwnkwhkw26mlpfdjgb63vq30x1d";
  };

  patches = [
    ./drop-untestable-database-backends.patch
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
  '';

  propagatedBuildInputs = [
    prometheus-client
  ];

  pythonImportsCheck = [
    "django_prometheus"
  ];

  checkInputs = [
    pytest-django
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Django middlewares to monitor your application with Prometheus.io";
    homepage = "https://github.com/korfuri/django-prometheus";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
