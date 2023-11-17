{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools

, cmdstanpy
, numpy
, matplotlib
, pandas
, holidays
, tqdm
, importlib-resources

, dask
, distributed

, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "prophet";
  version = "1.1.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "prophet";
    rev = version;
    hash = "sha256-liTg5Hm+FPpRQajBnnJKBh3JPGyu0Hflntf0isj1FiQ=";
  };

  sourceRoot = "source/python";

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

  passthru.optional-dependencies.parallel = [ dask distributed ] ++ dask.optional-dependencies.dataframe;

  preCheck = ''
    # use the generated files from $out for testing
    mv prophet/tests .
    rm -r prophet
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "prophet" ];

  meta = {
    changelog = "https://github.com/facebook/prophet/releases/tag/${src.rev}";
    description = "A tool for producing high quality forecasts for time series data that has multiple seasonality with linear or non-linear growth";
    homepage = "https://facebook.github.io/prophet/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux; # cmdstanpy doesn't currently build on darwin
  };
}
