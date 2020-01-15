{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "funcy";
  version = "1.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hxii7g4fn301vr8wg53jc1jkvbjlbaz1fbpgpn4362xcwzk73wi";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Collection of fancy functional tools focused on practicality";
    homepage = "https://funcy.readthedocs.org/";
    license = licenses.bsd3;
  };

}
