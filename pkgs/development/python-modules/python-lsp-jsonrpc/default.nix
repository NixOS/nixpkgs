{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
<<<<<<< HEAD
, pythonOlder
, setuptools
, setuptools-scm
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, ujson
}:

buildPythonPackage rec {
  pname = "python-lsp-jsonrpc";
<<<<<<< HEAD
  version = "1.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";
=======
  version = "1.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-XTvnDTaP5oweGSq1VItq+SEv7S/LrQq4YP1XQc3bxbk=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov-report html --cov-report term --junitxml=pytest.xml --cov pylsp_jsonrpc --cov test" ""
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

=======
    rev = "v${version}";
    sha256 = "0h4bs8s4axcm0p02v59amz9sq3nr4zhzdgwq7iaw6awl27v1hd0i";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    ujson
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "pylsp_jsonrpc"
  ];

  meta = with lib; {
    description = "Python server implementation of the JSON RPC 2.0 protocol";
    homepage = "https://github.com/python-lsp/python-lsp-jsonrpc";
    changelog = "https://github.com/python-lsp/python-lsp-jsonrpc/blob/v${version}/CHANGELOG.md";
=======
  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov-report html --cov-report term --junitxml=pytest.xml" "" \
      --replace "--cov pylsp_jsonrpc --cov test" ""
  '';

  pythonImportsCheck = [ "pylsp_jsonrpc" ];

  meta = with lib; {
    description = "Python server implementation of the JSON RPC 2.0 protocol.";
    homepage = "https://github.com/python-lsp/python-lsp-jsonrpc";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
