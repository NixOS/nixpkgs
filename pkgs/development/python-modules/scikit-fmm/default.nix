{
  lib,
  buildPythonPackage,
  fetchpatch,
  fetchPypi,
  meson-python,
  numpy,
  python,
}:

buildPythonPackage rec {
  pname = "scikit-fmm";
  version = "2023.4.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-14ccR/ggdyq6kvJWUe8U5NJ96M45PArjwCqzxuJCPAs=";
  };

  # TODO: Remove these patches after another stable release is made.
  # For now, these allow us to build with Python 3.12+ by switching to Meson
  # and off the deprecated distutils.
  patches = [
    (fetchpatch {
      name = "first-try-at-meson-build.patch";
      hash = "sha256-Kclg4YrQZL6ZSVsLh6X6DqdztPjDK35L5dp5PqYjzaY=";
      url = "https://github.com/scikit-fmm/scikit-fmm/commit/a52c0eccb70077553607a5084152316d136b668b.patch";
    })
    (fetchpatch {
      name = "work-in-progress-on-meson-build.patch";
      hash = "sha256-WvSwBz7exqe1H+CqdoMfT5jEoIHnyt/nbc/CryuEKiA=";
      url = "https://github.com/scikit-fmm/scikit-fmm/commit/db0e7a5f51541745027c3d081d7841e74587793e.patch";
    })
    (fetchpatch {
      name = "re-cythonize-the-heap-wrapper.patch";
      hash = "sha256-ro97+06R0szXQ9I8/sR4JAnFxoQwJeiImDcl1Yp9P0Y=";
      url = "https://github.com/scikit-fmm/scikit-fmm/commit/4168323e209343facd5f6ba93a85893242e781a2.patch";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "oldest-supported-numpy" "numpy"
  '';

  build-system = [ meson-python ];

  dependencies = [ numpy ];

  checkPhase = ''
    mkdir testdir; cd testdir
    ${python.interpreter} -c "import skfmm, sys; sys.exit(skfmm.test())"
  '';

  meta = with lib; {
    description = "A Python extension module which implements the fast marching method";
    homepage = "https://github.com/scikit-fmm/scikit-fmm";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
