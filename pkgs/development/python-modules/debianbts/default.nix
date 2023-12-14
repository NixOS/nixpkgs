{ lib
, buildPythonPackage
, fetchPypi
, pysimplesoap
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "python-debianbts";
  version = "4.0.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JbPb0lZND96XLZNU97wMuT9iGNXVN2KTsZC2St6FfuU=";
  };

  postPatch = ''
    sed -i "/--cov/d" pyproject.toml
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pysimplesoap
  ];

  # Most tests require network access
  doCheck = false;

  pythonImportsCheck = [
    "debianbts"
  ];

  meta = with lib; {
    description = "Python interface to Debian's Bug Tracking System";
    homepage = "https://github.com/venthur/python-debianbts";
    downloadPage = "https://pypi.org/project/python-debianbts/";
    changelog = "https://github.com/venthur/python-debianbts/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ nicoo ];
  };
}
