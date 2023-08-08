{ buildPythonPackage
, fetchFromGitHub
, lib
, passlib
, pytestCheckHook
, setuptools
, setuptools-git
, twine
, webtest
}:

buildPythonPackage rec {
  pname = "pypiserver";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-jub+iVL/YeGaG9Vzqyyfc4qFi0cR+7xrzuXNHL5W4p4=";
  };

  nativeBuildInputs = [ setuptools-git ];

  propagatedBuildInputs = [ setuptools ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  nativeCheckInputs = [
    passlib
    pytestCheckHook
    twine
    webtest
  ];

  disabledTests = [
    # fails to install the package
    "test_hash_algos"
    "test_pip_install_authed_succeeds"
    "test_pip_install_open_succeeds"
  ];

  disabledTestPaths = [
    # requires docker service running
    "docker/test_docker.py"
  ];

  pythonImportsCheck = [ "pypiserver" ];

  meta = with lib; {
    homepage = "https://github.com/pypiserver/pypiserver";
    description = "Minimal PyPI server for use with pip/easy_install";
    license = with licenses; [ mit zlib ];
    maintainers = with maintainers; [ austinbutler ];
  };
}
