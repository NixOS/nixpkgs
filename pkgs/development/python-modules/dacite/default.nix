{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
<<<<<<< HEAD
  pytestCheckHook,
  pythonAtLeast,
  setuptools,
=======
  pythonOlder,
  pytestCheckHook,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "dacite";
  version = "1.9.2";
<<<<<<< HEAD
  pyproject = true;
=======
  format = "setuptools";

  disabled = pythonOlder "3.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "konradhalas";
    repo = "dacite";
    tag = "v${version}";
    hash = "sha256-mAPqWvBpkTbtzHpwtCSDXMNkoc8/hbRH3OIEeK2yStU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--benchmark-autosave --benchmark-json=benchmark.json" ""
<<<<<<< HEAD
  ''
  + lib.optionalString (pythonAtLeast "3.14") ''
    substituteInPlace tests/core/test_union.py \
      --replace-fail "typing.Union[int, str]" "int | str"
  '';

  build-system = [ setuptools ];

=======
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dacite" ];

  disabledTestPaths = [ "tests/performance" ];

<<<<<<< HEAD
  meta = {
    description = "Python helper to create data classes from dictionaries";
    homepage = "https://github.com/konradhalas/dacite";
    changelog = "https://github.com/konradhalas/dacite/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python helper to create data classes from dictionaries";
    homepage = "https://github.com/konradhalas/dacite";
    changelog = "https://github.com/konradhalas/dacite/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
