{
  lib,
  buildPythonPackage,
  fetchpatch2,
  fetchFromGitHub,
  setuptools,
  cssselect,
  cssutils,
  lxml,
  requests,
  cachetools,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "premailer";
  version = "3.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "peterbe";
    repo = "premailer";
    rev = "f4ded0b9701c4985e7ff5c5beda83324c264ea62"; # no tags
    hash = "sha256-8ALdpR3aIDg0wP+JYCPY1f7mEJgdJm8xlLlgGpa0Sa4=";
  };

  patches = [
    # Migrate to pytest: https://github.com/peterbe/premailer/pull/288
    (fetchpatch2 {
      url = "https://github.com/peterbe/premailer/commit/afed2d515bbf3b99753abfae7435a44c352027e9.patch?full_index=1";
      hash = "sha256-aDProDHowThMBcVCRwXqcG17osHAeznDk4DFJ5Bv8kw=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    cachetools
    cssselect
    cssutils
    lxml
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportCheck = [
    "premailer"
    "premailer.cache"
    "premailer.merge_style"
  ];

  meta = {
    description = "Turns CSS blocks into style attributes";
    homepage = "https://github.com/peterbe/premailer";
    license = lib.licenses.bsd3;
  };
}
