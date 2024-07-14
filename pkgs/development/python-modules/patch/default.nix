{
  lib,
  buildPythonPackage,
  fetchzip,
}:

buildPythonPackage rec {
  version = "1.16";
  format = "setuptools";
  pname = "patch";

  src = fetchzip {
    url = "mirror://pypi/p/${pname}/${pname}-${version}.zip";
    hash = "sha256-DxSmGOvyXRHkUfNcOPK3Kt6Q+HJ+7oM7JV397TcsRdo=";
    stripRoot = false;
  };

  # No tests included in archive
  doCheck = false;

  meta = with lib; {
    description = "Library to parse and apply unified diffs";
    homepage = "https://github.com/techtonik/python-patch/";
    license = licenses.mit;
    maintainers = [ maintainers.igsha ];
  };
}
