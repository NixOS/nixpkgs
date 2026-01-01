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
<<<<<<< HEAD
  tomli,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "propcache";
<<<<<<< HEAD
  version = "0.4.1";
=======
  version = "0.3.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "propcache";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-7HQUOggbFC7kWcXqatLeCTNJqo0fW9FRCy8UkYL6wvM=";
=======
    hash = "sha256-G8SLIZaJUu3uwyFicrQF+PjKp3vsUh/pNUsmDpnnAAg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace packaging/pep517_backend/_backend.py \
<<<<<<< HEAD
      --replace "Cython ~=" "Cython >="
=======
      --replace "Cython ~= 3.0.12" Cython
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  build-system = [
    cython
    expandvars
    setuptools
<<<<<<< HEAD
  ]
  ++ lib.optionals (pythonOlder "3.11") [
    tomli
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
