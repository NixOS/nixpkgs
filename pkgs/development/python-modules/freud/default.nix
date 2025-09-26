{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  scikit-build-core,
  cython,
  oldest-supported-numpy,

  # nativeBuildInputs
  cmake,
  ninja,

  # buildInputs
  tbb_2022,
  nanobind,

  # dependencies
  numpy,
  rowan,
  scipy,
  parsnip,

  # tests
  pytestCheckHook,
  python,
  gsd,
  matplotlib,
  sympy,
}:

buildPythonPackage rec {
  pname = "freud";
  version = "3.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "glotzerlab";
    repo = "freud";
    tag = "v${version}";
    hash = "sha256-JX3pbzNTj85UTAtWYnDRvtJSjS27qgY/vitaAjmXbjA=";
    fetchSubmodules = true;
  };

  # Because we prefer to not `leaveDotGit`, we need to fool upstream into
  # thinking we left the .git files in the submodules, so cmake won't think we
  # didn't initialize them. Upstream doesn't support using the system wide
  # installed version of these libraries, and it's probably aint's worth the
  # hassle, because upstream also doesn't distribute all of these dependencies'
  # libraries, and probably it uses only what it needs.
  preConfigure = ''
    touch extern/{voro++,fsph,Eigen}/.git
  '';

  build-system = [
    scikit-build-core
    cython
    oldest-supported-numpy
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];
  dontUseCmakeConfigure = true;
  buildInputs = [
    tbb_2022
    nanobind
  ];

  dependencies = [
    numpy
    rowan
    scipy
    parsnip
  ];

  nativeCheckInputs = [
    pytestCheckHook
    gsd
    matplotlib
    sympy
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
    changelog = "https://github.com/glotzerlab/freud/blob/${src.tag}/ChangeLog.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
