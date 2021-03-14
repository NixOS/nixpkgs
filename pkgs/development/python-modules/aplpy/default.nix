{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, numpy
, astropy
, astropy-helpers
, matplotlib
, reproject
, pyavm
, pyregion
, pillow
, scikitimage
, shapely
, pytest
, pytest-astropy
}:

buildPythonPackage rec {
  pname = "aplpy";
  version = "2.0.3";
  format = "pyproject";

  src = fetchPypi {
    pname = "APLpy";
    inherit version;
    sha256 = "239f3d83635ca4251536aeb577df7c60df77fc4d658097b92094719739aec3f3";
  };

  patches = [ (fetchpatch {
      # Can be removed in next release after 2.0.3
      url = "https://github.com/aplpy/aplpy/pull/448.patch";
      sha256 = "1pnzh7ykjc8hwahzbzyryrzv5a8fddgd1bmzbhagkrn6lmvhhpvq";
      excludes = [ "tox.ini" "azure-pipelines.yml" ".circleci/config.yml" "MANIFEST.in" ".gitignore"
       "setup.cfg" "appveyor.yml" "readthedocs.yml" "CHANGES.rst" ".gitmodules" ".travis.yml" "astropy_helpers" ];
    })
  ];

  propagatedBuildInputs = [
    numpy
    astropy
    matplotlib
    reproject
    pyavm
    pyregion
    pillow
    scikitimage
    shapely
  ];

  nativeBuildInputs = [ astropy-helpers ];
  checkInputs = [ pytest pytest-astropy ];

  checkPhase = ''
    OPENMP_EXPECTED=0 pytest aplpy
  '';

  meta = with lib; {
    description = "The Astronomical Plotting Library in Python";
    homepage = "http://aplpy.github.io";
    license = licenses.mit;
    maintainers = [ maintainers.smaret ];
  };
}
