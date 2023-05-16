{ lib
, anyio
<<<<<<< HEAD
, buildPythonPackage
, curio
, fetchFromGitHub
, httpx
, hypothesis
, poetry-core
, pytest-aio
, pytest-subtests
, pytestCheckHook
, pythonOlder
=======
, curio
, buildPythonPackage
, fetchFromGitHub
, httpx
, hypothesis
, mypy
, poetry-core
, pytestCheckHook
, pytest-aio
, pytest-cov
, pytest-mypy
, pytest-mypy-plugins
, pytest-subtests
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, setuptools
, trio
, typing-extensions
}:

buildPythonPackage rec {
  pname = "returns";
<<<<<<< HEAD
  version = "0.22.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

=======
  version = "0.20.0";
  format = "pyproject";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "dry-python";
    repo = "returns";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-0eFirhBsj8SWfoAPWEMuFa+EvBgHKpNeKVj3qJ4L6hE=";
  };

  postPatch = ''
    sed -i setup.cfg \
      -e '/--cov.*/d' \
      -e '/--mypy.*/d'
  '';

=======
    hash = "sha256-28WYjrjmu3hQ8+Snuvl3ykTd86eWYI97AE60p6SVwDQ=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    typing-extensions
  ];

  nativeCheckInputs = [
    anyio
    curio
    httpx
    hypothesis
<<<<<<< HEAD
    pytestCheckHook
    pytest-aio
=======
    mypy
    pytestCheckHook
    pytest-aio
    pytest-cov
    pytest-mypy
    pytest-mypy-plugins
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytest-subtests
    setuptools
    trio
  ];

<<<<<<< HEAD
  preCheck = ''
    rm -rf returns/contrib/mypy
  '';

  pythonImportsCheck = [
    "returns"
  ];

  pytestFlagsArray = [
    "--ignore=typesafety"
  ];

  meta = with lib; {
    description = "Make your functions return something meaningful, typed, and safe!";
    homepage = "https://github.com/dry-python/returns";
    changelog = "https://github.com/dry-python/returns/blob/${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jessemoore ];
=======
  pytestFlagsArray = [ "--ignore=typesafety" ];

  meta = with lib; {
    description = "Make your functions return something meaningful, typed, and safe!";
    homepage = "returns.rtfd.io";
    license = licenses.bsd2;
    maintainers = [ maintainers.jessemoore ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
