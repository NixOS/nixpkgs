{ lib
, buildPythonPackage
, fetchPypi
}:


buildPythonPackage rec {
  pname = "regex";
  version = "2018.01.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "139678fc013b75e486e580c39b4c52d085ed7362e400960f8be1711a414f16b5";
  };

  meta = {
    description = "Alternative regular expression module, to replace re";
    homepage = "https://bitbucket.org/mrabarnett/mrab-regex";
    license = lib.licenses.psfl;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ abbradar ];
  };
}