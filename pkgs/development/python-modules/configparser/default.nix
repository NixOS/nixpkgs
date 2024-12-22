{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "configparser";
  version = "7.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "configparser";
    rev = "refs/tags/v${version}";
    hash = "sha256-6B1I/kS60opMDpCzy2tnlnV65Qo500G0zPHP1I5TDWA=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preConfigure = ''
    export LC_ALL=${if stdenv.hostPlatform.isDarwin then "en_US" else "C"}.UTF-8
  '';

  meta = with lib; {
    description = "Updated configparser from Python 3.7 for Python 2.6+";
    homepage = "https://github.com/jaraco/configparser";
    license = licenses.mit;
    maintainers = [ ];
  };
}
