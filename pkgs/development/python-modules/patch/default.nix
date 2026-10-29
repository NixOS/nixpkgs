{
  lib,
  buildPythonPackage,
  fetchzip,
}:

buildPythonPackage (finalAttrs: {
  version = "1.16";
  format = "setuptools";
  pname = "patch";

  src = fetchzip {
    url = "mirror://pypi/p/${finalAttrs.pname}/${finalAttrs.pname}-${finalAttrs.version}.zip";
    hash = "sha256-DxSmGOvyXRHkUfNcOPK3Kt6Q+HJ+7oM7JV397TcsRdo=";
    stripRoot = false;
  };

  # No tests included in archive
  doCheck = false;

  meta = {
    description = "Library to parse and apply unified diffs";
    homepage = "https://github.com/techtonik/python-patch/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.igsha ];
  };
})
