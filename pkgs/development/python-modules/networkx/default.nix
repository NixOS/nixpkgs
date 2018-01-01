{ lib
, buildPythonPackage
, fetchPypi
, nose
, decorator
, isPy36
, isPyPy
}:

buildPythonPackage rec {
  pname = "networkx";
  version = "1.11";

  # Currently broken on PyPy.
  # https://github.com/networkx/networkx/pull/1361
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f74s56xb4ggixiq0vxyfxsfk8p20c7a099lpcf60izv1php03hd";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ decorator ];

  # 17 failures with 3.6 https://github.com/networkx/networkx/issues/2396#issuecomment-304437299
  doCheck = !(isPy36);

  meta = {
    homepage = "https://networkx.github.io/";
    description = "Library for the creation, manipulation, and study of the structure, dynamics, and functions of complex networks";
    license = lib.licenses.bsd3;
  };
}