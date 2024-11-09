{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  cython,
  oldest-supported-numpy,
  scikit-build,
  setuptools,
  tbb,
  numpy,
  rowan,
  scipy,
  pytestCheckHook,
  python,
  gsd,
  matplotlib,
  sympy,
}:

buildPythonPackage rec {
  pname = "freud";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "glotzerlab";
    repo = "freud";
    rev = "refs/tags/v${version}";
    hash = "sha256-jlscEHQ1q4oqxE06NhVWCOlPRcjDcJVrvy4h6iYrkz0=";
    fetchSubmodules = true;
  };

  patches = [
    # https://github.com/glotzerlab/freud/issues/1269
    (fetchpatch {
      url = "https://github.com/glotzerlab/freud/commit/8f636e3815737945e45da5b9996b5f69df07c9a5.patch";
      hash = "sha256-PLorRrYj16oBWHYzXDq62kECzVTtyr+1Z20DJqTkXxg=";
    })
  ];

  # Because we prefer to not `leaveDotGit`, we need to fool upstream into
  # thinking we left the .git files in the submodules, so cmake won't think we
  # didn't initialize them. Upstream doesn't support using the system wide
  # installed version of these libraries, and it's probably aint's worth the
  # hassle, because upstream also doesn't distribute all of these dependencies'
  # libraries, and probably it uses only what it needs.
  preConfigure = ''
    touch extern/{voro++,fsph,Eigen}/.git
  '';

  # Scipy still depends on numpy 1, and so we'd get 'package duplicates in
  # closure' error if we'd use numpy_2
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'numpy>=2.0.0rc1' 'numpy' \
  '';

  nativeBuildInputs = [
    cmake
    cython
    oldest-supported-numpy
    scikit-build
    setuptools
  ];
  dontUseCmakeConfigure = true;
  buildInputs = [ tbb ];

  propagatedBuildInputs = [
    numpy
    rowan
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    gsd
    matplotlib
    sympy
  ];
  disabledTests = lib.optionals stdenv.hostPlatform.isAarch64 [
    # https://github.com/glotzerlab/freud/issues/961
    "test_docstring"
  ];
  # On top of cd $out due to https://github.com/NixOS/nixpkgs/issues/255262 ,
  # we need to also copy the tests because otherwise pytest won't find them.
  preCheck = ''
    cp -R tests $out/${python.sitePackages}/freud/tests
    cd $out
  '';

  pythonImportsCheck = [ "freud" ];

  meta = {
    description = "Powerful, efficient particle trajectory analysis in scientific Python";
    homepage = "https://github.com/glotzerlab/freud";
    changelog = "https://github.com/glotzerlab/freud/blob/${src.rev}/ChangeLog.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
