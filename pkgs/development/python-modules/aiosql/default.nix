{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pg8000,
<<<<<<< HEAD
  psycopg,
  pytest-asyncio,
  pytest-postgresql,
=======
  pytest-asyncio,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
  sphinx-rtd-theme,
  sphinxHook,
}:

buildPythonPackage rec {
  pname = "aiosql";
<<<<<<< HEAD
  version = "14.1";
  pyproject = true;

  outputs = [
    "out"
    "doc"
=======
  version = "13.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  outputs = [
    "doc"
    "out"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  src = fetchFromGitHub {
    owner = "nackjicholson";
    repo = "aiosql";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-BNsjVVyYRfp3sNdzQwHy9nQveP2AHfXGK10DLybat9I=";
=======
    hash = "sha256-a3pRzcDMXdaDs0ub6k5bPRwnk+RCbxZ7ceIt8/fMSPg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  sphinxRoot = "docs/source";

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    sphinx-rtd-theme
    sphinxHook
  ];

<<<<<<< HEAD
  nativeCheckInputs = [
    pg8000
    psycopg
    pytest-asyncio
    pytest-postgresql
=======
  propagatedBuildInputs = [ pg8000 ];

  nativeCheckInputs = [
    pytest-asyncio
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiosql" ];

<<<<<<< HEAD
  meta = {
    description = "Simple SQL in Python";
    homepage = "https://nackjicholson.github.io/aiosql/";
    changelog = "https://github.com/nackjicholson/aiosql/releases/tag/${src.tag}";
    license = with lib.licenses; [ bsd2 ];
    maintainers = with lib.maintainers; [ kaction ];
=======
  meta = with lib; {
    description = "Simple SQL in Python";
    homepage = "https://nackjicholson.github.io/aiosql/";
    changelog = "https://github.com/nackjicholson/aiosql/releases/tag/${src.tag}";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ kaction ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
