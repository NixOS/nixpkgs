{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  numpy,
  pybind11,
  setuptools,
  setuptools-scm,

  # buildInputs
  eigen,

  # tests
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "celerite";
  version = "0.4.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dfm";
    repo = "celerite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mvItSBAnR/NHgakZMkrL6GblA1UyX4jRC+l8Hh8PXHE=";
  };

  # Use nixpkgs' eigen instead of the git submodule
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"cpp/lib/eigen"' '"${eigen}/include/eigen3"'
  '';

  build-system = [
    numpy
    pybind11
    setuptools
    setuptools-scm
  ];

  buildInputs = [ eigen ];

  dependencies = [ numpy ];

  pythonImportsCheck = [ "celerite" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Prevent the source directory from shadowing the installed package (with its compiled extension)
  preCheck = ''
    rm -rf celerite
  '';

  meta = {
    description = "Scalable 1D Gaussian Processes";
    homepage = "https://github.com/dfm/celerite";
    changelog = "https://github.com/dfm/celerite/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
