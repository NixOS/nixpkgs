{
  lib,
  buildPythonPackage,
  fetchurl,
  glibcLocales,
}:

buildPythonPackage (finalAttrs: {
  pname = "rpmfluff";
  version = "0.5.7.1";
  format = "setuptools";

  src = fetchurl {
    url = "https://releases.pagure.org/${finalAttrs.pname}/${finalAttrs.pname}-${finalAttrs.version}.tar.xz";
    hash = "sha256-QWtHUpxRKa43BixaDQ0YxoPA+MBg9hgbfAospOqndqc=";
  };

  env.LC_ALL = "en_US.utf-8";
  buildInputs = [ glibcLocales ];

  meta = {
    description = "Lightweight way of building RPMs, and sabotaging them";
    homepage = "https://pagure.io/rpmfluff";
    license = lib.licenses.gpl2;
  };
})
