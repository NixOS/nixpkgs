{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchpatch

, setuptools

, cmdstanpy
, numpy
, matplotlib
, pandas
, lunarcalendar
, convertdate
, holidays
, python-dateutil
, tqdm
, importlib-resources

, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "prophet";
  version = "1.1.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "prophet";
    rev = "refs/tags/v${version}";
    hash = "sha256-pbJ0xL5wDZ+rKgtQQTJPsB1Mu2QXo3S9MMpiYkURsz0=";
  };

  patches = [
    # TODO: remove when bumping version from 1.1.4
    (fetchpatch {
      name = "fix-stan-file-temp-dest.patch";
      url = "https://github.com/facebook/prophet/commit/374676500795aec9d5cbc7fe5f7a96bf00489809.patch";
      hash = "sha256-sfiQ2V3ZEF0WM9oM1FkL/fhZesQJ1i2EUPYJMdDA2UM=";
      relative = "python";
    })
  ];

  sourceRoot = "${src.name}/python";

  env.PROPHET_REPACKAGE_CMDSTAN = "false";

  nativeBuildInputs = [ setuptools ];

  # TODO: update when bumping version from 1.1.4
  propagatedBuildInputs = [
    cmdstanpy
    numpy
    matplotlib
    pandas
    lunarcalendar
    convertdate
    holidays
    python-dateutil
    tqdm
    importlib-resources
  ];

  preCheck = ''
    # the generated stan_model directory only exists in build/lib*
      cd build/lib*
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "prophet" ];

  meta = {
    homepage = "https://facebook.github.io/prophet/";
    description = "A tool for producing high quality forecasts for time series data that has multiple seasonality with linear or non-linear growth";
    changelog = "https://github.com/facebook/prophet/releases/tag/v${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
