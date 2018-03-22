{ stdenv, buildPythonPackage, fetchPypi, pytest, future, numpy }:

buildPythonPackage rec {
  pname = "MDP";
  version = "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0aw1zxmyvx6gfmmnixbqmdaah28jl7rmqkzhxv53091asc23iw9k";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ future numpy ];

  # Tests disabled because of missing dependencies not in nix
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Library for building complex data processing software by combining widely used machine learning algorithms";
    homepage = http://mdp-toolkit.sourceforge.net;
    license = licenses.bsd3;
    maintainers = with maintainers; [ nico202 ];
  };
}
