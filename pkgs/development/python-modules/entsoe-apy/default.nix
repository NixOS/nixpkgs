{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  isodate,
  httpx,
  loguru,
  xsdata-pydantic,
}:

buildPythonPackage rec {
  pname = "entsoe-apy";
<<<<<<< HEAD
  version = "0.7.0";
=======
  version = "0.6.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "berrij";
    repo = "entsoe-apy";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ui+F9EOz95yCfn52pSsxDs9p6d0a2g3VpxHd3WjU9W0=";
=======
    hash = "sha256-pjn4S5jrocLLi0Hc5TmteQiNkGBW6ZcT4VzBymXqv+8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  pyproject = true;
  build-system = [ setuptools ];

  dependencies = [
    httpx
    loguru
    xsdata-pydantic
    isodate
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "entsoe"
  ];

  meta = {
    description = "Python Package to Query the ENTSO-E API";
    homepage = "https://github.com/berrij/entsoe-apy";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ berrij ];
    platforms = lib.platforms.all;
  };
}
