{ stdenv
, fetchPypi
, buildPythonPackage
}:
buildPythonPackage rec {

  pname = "ez_setup";
  version = "0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "303c5b17d552d1e3fb0505d80549f8579f557e13d8dc90e5ecef3c07d7f58642";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/ActiveState/ez_setup";
    license = licenses.psfl;
    description = "Yet another Python setup tool.";
  };

}
