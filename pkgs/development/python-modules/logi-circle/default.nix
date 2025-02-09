{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, aiohttp
, python-slugify
, pytz
, aresponses
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "logi-circle";
  version = "0.2.3";

  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "evanjd";
    repo = "python-logi-circle";
    rev = "v${version}";
    hash = "sha256-Q+uoaimJjn6MiO3jXGYyZ6cS0tqI06Azkq1QbNq2FN8=";
  };

  propagatedBuildInputs = [
    aiohttp
    python-slugify
    pytz
  ];

  nativeCheckInputs = [
    aresponses
    pytestCheckHook
  ];

  pythonImportsCheck = [ "logi_circle" ];

  meta = {
    description = "A Python library to communicate with Logi Circle cameras";
    homepage = "https://github.com/evanjd/python-logi-circle";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
