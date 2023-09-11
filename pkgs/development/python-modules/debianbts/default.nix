{ lib
, buildPythonPackage
, fetchPypi
, nix-update-script
, pysimplesoap
, pytest , pytest-xdist
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "python-debianbts";
  version = "4.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";
  passthru.updateScript = nix-update-script { };

  src = fetchPypi {
    inherit pname version;
    sha256 = "b0817d593ccdfb58a5f37b8cb3873bd0b2268b434f2798dc75b206d7550fdf04";
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
