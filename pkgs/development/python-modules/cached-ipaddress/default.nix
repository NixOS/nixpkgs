{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "cached-ipaddress";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "cached-ipaddress";
    rev = "refs/tags/v${version}";
    hash = "sha256-iTQ1DSCZqjAzsf95nYUxnNj5YCb1Y4JIUW5VGIi7yoY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=cached_ipaddress --cov-report=term-missing:skip-covered" "" \
      --replace "Cython>=3.0.5" "Cython"
  '';

  nativeBuildInputs = [
    cython
    poetry-core
    setuptools
    wheel
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cached_ipaddress" ];

  meta = with lib; {
    description = "Cache construction of ipaddress objects";
    homepage = "https://github.com/bdraco/cached-ipaddress";
    changelog = "https://github.com/bdraco/cached-ipaddress/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
