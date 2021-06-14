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

  patches = [
    # Fixes compatibility with astropy-helpers. This patch has been merged into
    # the master branch as of May 2020, and should be part of the next
    # upstream release (v2.0.3 was tagged in Feb. 2019).
    (fetchpatch {
      url = "https://github.com/aplpy/aplpy/pull/448.patch";
      sha256 = "1pnzh7ykjc8hwahzbzyryrzv5a8fddgd1bmzbhagkrn6lmvhhpvq";
      excludes = [ "tox.ini" "azure-pipelines.yml" ".circleci/config.yml" "MANIFEST.in" ".gitignore"
       "setup.cfg" "appveyor.yml" "readthedocs.yml" "CHANGES.rst" ".gitmodules" ".travis.yml" "astropy_helpers" ];
    })
    # Fix for matplotlib >= 3.4 (https://github.com/aplpy/aplpy/pull/466)
    # Note: because of a security thing, github will refuse to serve this patch from the
    # "normal" location
    # (https://github.com/aplpy/aplpy/commit/56c1cc694fdea69e7da8506d3212c4495adb0ca5.patch)
    # due to the fact that it contains the PDF magic bytes, but it will serve it from
    # this githubusercontent domain.
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/aplpy/aplpy/pull/466/commit/56c1cc694fdea69e7da8506d3212c4495adb0ca5.patch";
      sha256 = "0jna2n1cgfzr0a27m5z94wwph7qg25hs7lycrdb2dp3943rb35g4";
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
