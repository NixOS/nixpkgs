{ lib
, buildPythonPackage
, cython
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "frozenlist";
  version = "1.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-sI6jnrTxDbW0sNVodpCjBnA31VAAmunwMp9s8GkoHGI=";
  };

  nativeBuildInputs = [
    cython
    setuptools
    wheel
  ];

  postPatch = ''
    sed -i "/addopts =/d" pytest.ini
  '';

  preBuild = ''
    cython frozenlist/_frozenlist.pyx
  '';

  pythonImportsCheck = [
    "frozenlist"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Python module for list-like structure";
    homepage = "https://github.com/aio-libs/frozenlist";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
