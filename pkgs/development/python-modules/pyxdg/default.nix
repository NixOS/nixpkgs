{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
}:

buildPythonPackage rec {
  pname = "pyxdg";
  version = "0.28";
  format = "setuptools";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "xdg";
    repo = "pyxdg";
    rev = "rel-${version}";
    hash = "sha256-TrFQzfkXabmfpGYwhxD1UVY1F645KycfSPPrMJFAe+0=";
  };

  # Tests failed (errors=4, failures=4) on NixOS
  doCheck = false;

  pythonImportsCheck = [ "xdg" ];

  meta = {
    homepage = "http://freedesktop.org/wiki/Software/pyxdg";
    description = "Contains implementations of freedesktop.org standards";
    license = lib.licenses.lgpl2;
    maintainers = [ ];
  };
}
