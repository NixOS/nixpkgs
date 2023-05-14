{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, astropy-extension-helpers
, astropy-helpers
, cython
, jinja2
, setuptools-scm
, numpy
, packaging
, pyerfa
, pyyaml
}:

buildPythonPackage rec {
  pname = "astropy";
  version = "5.2.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5qnjRxa9pZRXiDU8Y/BkRyHuflRH0Wsc3LWMSKlrDZw=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    astropy-extension-helpers
    astropy-helpers
    cython
    jinja2
    setuptools-scm
  ];

  propagatedBuildInputs = [
    numpy
    packaging
    pyerfa
    pyyaml
  ];

  # infinite recursion with pytest-astropy (pytest-astropy-header depends on astropy itself)
  doCheck = false;

  meta = with lib; {
    description = "Astronomy/Astrophysics library for Python";
    homepage = "https://www.astropy.org";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ kentjames ];
  };
}
