{ lib
, buildPythonPackage
, fetchFromGitHub
, django
}:

buildPythonPackage rec {
  pname = "drf-spectacular-sidecar";
  version = "2022.11.1";

  src = fetchFromGitHub {
    owner = "tfranzel";
    repo = "drf-spectacular-sidecar";
    rev = version;
    sha256 = "sha256-ztUdV+Bhi3zx5UiwnpiQM/RglUH1n9J48Beuq2GPWdg=";
  };

  propagatedBuildInputs = [
    django
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "drf_spectacular_sidecar" ];

  meta = with lib; {
    description = "Serve self-contained distribution builds of Swagger UI and Redoc with Django";
    homepage = "https://github.com/tfranzel/drf-spectacular-sidecar";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
