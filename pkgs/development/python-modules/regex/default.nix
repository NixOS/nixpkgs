{ lib
, buildPythonPackage
, fetchPypi
}:


buildPythonPackage rec {
  pname = "regex";
  version = "2018.02.21";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b44624a38d07d3c954c84ad302c29f7930f4bf01443beef5589e9157b14e2a29";
  };

  meta = {
    description = "Alternative regular expression module, to replace re";
    homepage = https://bitbucket.org/mrabarnett/mrab-regex;
    license = lib.licenses.psfl;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ abbradar ];
  };
}
