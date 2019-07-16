{ buildPythonPackage
, fetchPypi
, future
, pkgs
}:

buildPythonPackage rec {
  pname = "ana";
  version = "0.06";

  propagatedBuildInputs = [ future ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "5fa16e511773a0efc6ac9294f93eee583612ffb580859737eed07e703947d6f8";
  };

  meta = with pkgs.lib; {
    description = "Easy distributed data storage for stuff";
    homepage = "https://github.com/zardus/ana";
    license = licenses.bsd2;
    maintainers = [ maintainers.pamplemousse ];
  };
}
