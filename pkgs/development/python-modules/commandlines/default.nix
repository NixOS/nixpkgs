{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "commandlines";
  version = "0.4.1";
  format = "setuptools";

  # PyPI source tarballs omit tests, fetch from Github instead
  src = fetchFromGitHub {
    owner = "chrissimpkins";
    repo = "commandlines";
    rev = "v${finalAttrs.version}";
    hash = "sha256-x3iUeOTAaTKNW5Y5foMPMJcWVxu52uYZoY3Hhe3UvQ4=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python library for command line argument parsing";
    homepage = "https://github.com/chrissimpkins/commandlines";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ danc86 ];
  };
})
