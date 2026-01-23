{
  lib,
  buildPythonPackage,
  cython,
  expandvars,
  fetchFromGitHub,
  pytest-codspeed,
  pytest-cov-stub,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  tomli,
}:

buildPythonPackage rec {
  pname = "propcache";
  version = "0.4.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "propcache";
    tag = "v${version}";
    hash = "sha256-7HQUOggbFC7kWcXqatLeCTNJqo0fW9FRCy8UkYL6wvM=";
  };

  postPatch = ''
    substituteInPlace packaging/pep517_backend/_backend.py \
      --replace "Cython ~=" "Cython >="
  '';

  build-system = [
    cython
    expandvars
    setuptools
  ]
  ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  nativeCheckInputs = [
    pytest-codspeed
    pytest-cov-stub
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "propcache" ];

  meta = {
    description = "Fast property caching";
    homepage = "https://github.com/aio-libs/propcache";
    changelog = "https://github.com/aio-libs/propcache/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
