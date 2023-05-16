{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder

# build time
, astropy-extension-helpers
<<<<<<< HEAD
, cython
, jinja2
, oldest-supported-numpy
, setuptools-scm
, wheel
=======
, astropy-helpers
, cython
, jinja2
, setuptools-scm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

# runtime
, numpy
, packaging
, pyerfa
, pyyaml
}:

let
  pname = "astropy";
  version = "5.2.1";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  disabled = pythonOlder "3.8"; # according to setup.cfg

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9q4noHf46oSQPvp2x5C5hWFzQaAISw0hw5H3o/MyrCM=";
  };

<<<<<<< HEAD
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'cython==' 'cython>='
  '';

  nativeBuildInputs = [
    astropy-extension-helpers
    cython
    jinja2
    oldest-supported-numpy
    setuptools-scm
    wheel
=======
  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    astropy-extension-helpers
    astropy-helpers
    cython
    jinja2
    setuptools-scm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    maintainers = [ maintainers.kentjames ];
  };
}
