{
  lib,
  python3Packages,
  fetchPypi,
}:
python3Packages.buildPythonApplication rec {
  pname = "watchgha";
<<<<<<< HEAD
  version = "2.5.0";
=======
  version = "2.4.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "watchgha";
<<<<<<< HEAD
    hash = "sha256-jjQk/X9kd8qhqgvivSIsvg0BOp6zh6yqpPiAS6ak/Ps=";
=======
    hash = "sha256-RtmCC+twOk+viWY7WTbTzuxHTM3MOww+sRuEvlemCcI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    click
    dulwich
    exceptiongroup
    httpx
    rich
    trio
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
  ];

  pythonImportsCheck = [ "watchgha" ];

  meta = {
    description = "Live display of current GitHub action runs";
    mainProgram = "watch_gha_runs";
    homepage = "https://github.com/nedbat/watchgha";
    license = lib.licenses.apsl20;
    maintainers = with lib.maintainers; [ purcell ];
    platforms = lib.platforms.all;
  };
}
