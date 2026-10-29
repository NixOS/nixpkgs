{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  inform,
  sly,
}:

buildPythonPackage (finalAttrs: {
  pname = "quantiphy-eval";
  version = "0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KenKundert";
    repo = "quantiphy_eval";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7VHcuINhe17lRNkHUnZkVOEtD6mVWk5gu0NbrLZwprg=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    inform
    sly
  ];

  # this has a circular dependency on quantiphy
  preBuild = ''
    sed -i '/quantiphy>/d' ./pyproject.toml
  '';

  # tests require quantiphy import
  doCheck = false;

  # Also affected by the circular dependency on quantiphy
  # pythonImportsCheck = [
  #   "quantiphy_eval"
  # ];

  meta = {
    description = "QuantiPhy support for evals in-line";
    homepage = "https://github.com/KenKundert/quantiphy_eval/";
    changelog = "https://github.com/KenKundert/quantiphy_eval/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jpetrucciani ];
  };
})
