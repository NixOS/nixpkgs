{ lib
, buildPythonPackage
, fetchPypi
}:


buildPythonPackage rec {
  pname = "regex";
  version = "2018.02.08";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2353c0e983c4029caf32016f1dddef623c3117ac282a818468c6d2f5d541698d";
  };

  meta = {
    description = "Alternative regular expression module, to replace re";
    homepage = https://bitbucket.org/mrabarnett/mrab-regex;
    license = lib.licenses.psfl;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ abbradar ];
  };
}
