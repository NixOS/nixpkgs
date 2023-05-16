{ lib
, buildPythonPackage
, fetchFromGitHub
, cffi
<<<<<<< HEAD
, pytestCheckHook
, pytest-mock
, pythonOlder
, R
, rPackages
, six
}:

buildPythonPackage rec {
  pname = "rchitect";
  version = "0.4.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";
=======
, six
, pytestCheckHook
, pytest-mock
, R
, rPackages }:

buildPythonPackage rec {
  pname = "rchitect";
  version = "0.3.40";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "randy3k";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-e0xCUp5WBP4UKPkwPfrouNNYTBEnhlHHlkBQmghQfdk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
=======
    rev = "v${version}";
    sha256 = "yJMiPmusZ62dd6+5VkA2uSjq57a0C3arG8CgiUUHKpk=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace '"pytest-runner"' ""
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  propagatedBuildInputs = [
    cffi
    six
  ] ++ (with rPackages; [
    reticulate
  ]);

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    R
  ];

  preCheck = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${R}/lib/R/lib
    cd $TMPDIR
  '';

  pythonImportsCheck = [ "rchitect" ];

  meta = with lib; {
    description = "Interoperate R with Python";
    homepage = "https://github.com/randy3k/rchitect";
<<<<<<< HEAD
    changelog = "https://github.com/randy3k/rchitect/blob/v${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ savyajha ];
  };
}
