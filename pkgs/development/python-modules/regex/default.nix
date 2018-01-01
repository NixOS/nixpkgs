{ lib
, buildPythonPackage
, fetchPypi
}:


buildPythonPackage rec {
  pname = "regex";
  version = "2017.12.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ee069308c2757e565cc2b6f417ba5288e76cfe4c1764b6826063f4fbd53219d7";
  };

  meta = {
    description = "Alternative regular expression module, to replace re";
    homepage = "https://bitbucket.org/mrabarnett/mrab-regex";
    license = lib.licenses.psfl;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ abbradar ];
  };
}