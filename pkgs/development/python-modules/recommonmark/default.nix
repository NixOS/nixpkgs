{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  commonmark,
  docutils,
  sphinx,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "recommonmark";
  version = "0.7.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rtfd";
    repo = "recommonmark";
    rev = version;
    hash = "sha256-6Qw0fq1pTu9lIIEk3qpK+I3l8qPb9bk8YAC/1asmlU8=";
  };

  nativeCheckInputs = [ pytestCheckHook ];
  propagatedBuildInputs = [
    commonmark
    docutils
    sphinx
  ];

  disabledTests = [
    # https://github.com/readthedocs/recommonmark/issues/164
    "test_lists"
    "test_integration"
  ];

  doCheck = !isPy3k; # Not yet compatible with latest Sphinx.
  pythonImportsCheck = [ "recommonmark" ];

  meta = {
    description = "Docutils-compatibility bridge to CommonMark";
    homepage = "https://github.com/rtfd/recommonmark";
    license = lib.licenses.mit;
  };
}
