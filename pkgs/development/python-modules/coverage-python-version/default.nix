{ lib, buildPythonPackage, fetchzip
, setuptools, pytest, twine, wheel, coverage
}:

buildPythonPackage rec {
  pname = "coverage-python-version";
  version = "0.2.0";

  src = fetchzip {
    url = "https://github.com/jayclassless/coverage_python_version/archive/refs/tags/${version}.zip";
    sha256 = "0ip13n75qxjqy3v9nsmw3xg62nxbgwf435pavvmkk7cgwgqjscss";
  };

  propagatedBuildInputs = [
    # from pyproject.toml
    setuptools
    # from requirements.txt
    pytest
    twine
    wheel
    # from setup.py
    coverage
  ];

  meta = with lib; {
    description = "A coverage.py plugin to facilitate exclusions based on Python version ";
    downloadPage = "https://pypi.org/project/coverage-python-version/";
    homepage = "https://github.com/jayclassless/coverage_python_version";
    license = licenses.mit;
    maintainers = with maintainers; [ superherointj ];
  };
}
