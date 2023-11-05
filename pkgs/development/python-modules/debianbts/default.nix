{ lib
, buildPythonPackage
, fetchPypi
, nix-update-script
, pysimplesoap
, pytest
, pytest-xdist
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "python-debianbts";
  version = "4.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";
  passthru.updateScript = nix-update-script { };

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-JbPb0lZND96XLZNU97wMuT9iGNXVN2KTsZC2St6FfuU=";
  };

  buildInputs = [ setuptools ];
  propagatedBuildInputs = [ pysimplesoap ];
  checkInputs = [
    pytest
    pytest-xdist
  ];

  meta = with lib; {
    description = "Python interface to Debian's Bug Tracking System";
    homepage = "https://github.com/venthur/python-debianbts";
    downloadPage = "https://pypi.org/project/python-debianbts/";
    changelog = "https://github.com/venthur/python-debianbts/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.nicoo ];
  };
}
