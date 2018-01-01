{ lib
, buildPythonPackage
, fetchPypi
}:


buildPythonPackage rec {
  pname = "regex";
  version = "2016.11.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "126ds2b355n3pgl7brshhscpxn14ycs0yznzl8k4akj4sps1i6c6";
  };

  meta = {
    description = "Alternative regular expression module, to replace re";
    homepage = "https://bitbucket.org/mrabarnett/mrab-regex";
    license = lib.licenses.psfl;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ abbradar ];
  };
}