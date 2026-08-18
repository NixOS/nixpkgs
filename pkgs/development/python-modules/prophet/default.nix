{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  cmdstanpy,
  numpy,
  matplotlib,
  pandas,
  holidays,
  tqdm,
  importlib-resources,

  dask,
  distributed,

  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "prophet";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "prophet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Bu+ztg6sj1jh2iair6v1CdbF0Fi4b+h8yLzB3xTMD3Y=";
  };

  sourceRoot = "${finalAttrs.src.name}/python";

  env.PROPHET_REPACKAGE_CMDSTAN = "false";

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    cmdstanpy
    numpy
    matplotlib
    pandas
    holidays
    tqdm
    importlib-resources
  ];

  optional-dependencies.parallel = [
    dask
    distributed
  ]
  ++ dask.optional-dependencies.dataframe;

  preCheck = ''
    # use the generated files from $out for testing
    mv prophet/tests .
    rm -r prophet
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "prophet" ];

  meta = {
    changelog = "https://github.com/facebook/prophet/releases/tag/${finalAttrs.src.tag}";
    description = "Tool for producing high quality forecasts for time series data that has multiple seasonality with linear or non-linear growth";
    homepage = "https://facebook.github.io/prophet/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
})
