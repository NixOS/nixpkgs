{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  uv-build,

  # dependencies
  niapy,
  nltk,
  numpy,
  pandas,
  plotly,
  scikit-learn,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "niaarm";
  # nixpkgs-update: no auto update
  version = "0.4.7";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "NiaARM";
    tag = finalAttrs.version;
    hash = "sha256-uDoYyG5O7U/c/ypmlb7bZhVdBq8EZIi7AGunskQGmlY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.17,<0.10.0" "uv_build"
  '';

  pythonRelaxDeps = [
    "numpy"
    "plotly"
    "scikit-learn"
  ];

  build-system = [ uv-build ];

  dependencies = [
    niapy
    nltk
    numpy
    pandas
    plotly
    scikit-learn
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    # Prevents 'Fatal Python error: Aborted' on darwin during checkPhase
    MPLBACKEND = "Agg";
  };

  disabledTests = [
    # Test requires extra nltk data dependency
    "test_text_mining"

    # _vec was only set via private/deperecated API _get_vector
    # https://github.com/matplotlib/matplotlib/blob/6db3896c8e9476c0289c6b9742caae4adeade549/doc/api/prev_api_changes/api_changes_3.10.0/deprecations.rst?plain=1#L31
    "test_hill_slopes"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "niaarm" ];

  meta = {
    description = "Minimalistic framework for Numerical Association Rule Mining";
    mainProgram = "niaarm";
    homepage = "https://github.com/firefly-cpp/NiaARM";
    changelog = "https://github.com/firefly-cpp/NiaARM/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ firefly-cpp ];
  };
})
