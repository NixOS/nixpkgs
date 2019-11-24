{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "geographiclib";
  version = "1.50";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cn6ap5fkh3mkfa57l5b44z3gvz7j6lpmc9rl4g2jny2gvp4dg8j";
  };

  meta = with stdenv.lib; {
    homepage = "https://geographiclib.sourceforge.io";
    description = "Algorithms for geodesics (Karney, 2013) for solving the direct and inverse problems for an ellipsoid of revolution";
    license = licenses.mit;
    maintainers = with maintainers; [ va1entin ];
  };

}
