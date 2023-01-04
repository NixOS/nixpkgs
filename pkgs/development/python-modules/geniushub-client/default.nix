{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "geniushub-client";
  version = "0.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "manzanotti";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-amsMZjCsPI8CUfSct4uumn8nVZDESlQFh19LXu3yb7o=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'VERSION = os.environ["GITHUB_REF_NAME"]' "" \
      --replace "version=VERSION," 'version="${version}",'
  '';

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "geniushubclient"
  ];

  meta = with lib; {
    description = "Module to interact with Genius Hub systems";
    homepage = "https://github.com/manzanotti/geniushub-client";
    changelog = "https://github.com/manzanotti/geniushub-client/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
