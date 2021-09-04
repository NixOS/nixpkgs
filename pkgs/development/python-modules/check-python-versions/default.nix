{ lib, buildPythonPackage, fetchPypi
, pyyaml
, coverage, flake8, mypy, types-pyyaml, isort, check-manifest, check-python-versions
}:

buildPythonPackage rec {
  pname = "check-python-versions";
  version = "0.18.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6cc06a5ccc0b9efd8e3c9cbce0b3d6bf4aed3b78f22b9c66f90c4774008c04bf";
  };

  propagatedBuildInputs = [
    pyyaml
  ];

  checkInputs = [
    coverage
    flake8
    mypy
    types-pyyaml
    isort
    check-manifest
    (check-python-versions.overridePythonAttrs (oldAttrs: rec { doCheck = false; }))
  ];

  meta = with lib; {
    description = "Check that supported Python versions in a setup.py match tox.ini, .travis.yml and a bunch of other files";
    downloadPage = "https://pypi.org/project/check-python-versions/";
    homepage = "https://github.com/mgedmin/check-python-versions/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ superherointj ];
  };
}
