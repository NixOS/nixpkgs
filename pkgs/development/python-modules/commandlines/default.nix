{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "commandlines";
  version = ".0.2.1";
  format = "setuptools";

  # PyPI source tarballs omit tests, fetch from Github instead
  src = fetchFromGitHub {
    owner = "chrissimpkins";
    repo = "commandlines";
    rev = "v${version}";
    hash = "sha256-+zZOexTbOaAg3IXKR6uqKZizV7N4UvDrhSS9FR40GEA=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python library for command line argument parsing";
    homepage = "https://github.com/chrissimpkins/commandlines";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ danc86 ];
  };
}
