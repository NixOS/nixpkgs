{
  lib,
  buildPythonPackage,
  fetchPypi,
  dulwich,
  everett,
  importlib-metadata,
  jsonschema,
  numpy,
  psutil,
  python-box,
  requests,
  requests-toolbelt,
  rich,
  semantic-version,
  sentry-sdk,
  setuptools,
  simplejson,
  urllib3,
  wrapt,
  wurlitzer,
}:

buildPythonPackage rec {
  pname = "comet-ml";
<<<<<<< HEAD
  version = "3.55.0";
=======
  version = "3.54.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchPypi {
    pname = "comet_ml";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-bNfh6tVpsU2LrSLcAKy5lXLgd4lbo3/6dzzMB4+Eh08=";
=======
    hash = "sha256-loe7Yz/I1hvxZlvjEP610kdHgvGVAYzx90RxhwopoQE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  pyproject = true;
  build-system = [
    setuptools
  ];

  dependencies = [
    dulwich
    everett
    importlib-metadata
    jsonschema
    numpy
    psutil
    python-box
    requests
    requests-toolbelt
    rich
    semantic-version
    sentry-sdk
    simplejson
    urllib3
    wrapt
    wurlitzer
  ];

  pythonRelaxDeps = [
    "everett"
    "python-box"
  ];

  pythonImportsCheck = [ "comet_ml" ];

  meta = {
    description = "Platform designed to help machine learning teams track, compare, explain, and optimize their models";
    homepage = "https://www.comet.com/site/";
    changelog = "https://www.comet.com/docs/v2/api-and-sdk/python-sdk/releases/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
    mainProgram = "comet";
  };
}
