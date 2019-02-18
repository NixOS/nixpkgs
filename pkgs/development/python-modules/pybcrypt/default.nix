{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pybcrypt";
  version = "0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5fa13bce551468350d66c4883694850570f3da28d6866bb638ba44fe5eabda78";
  };

  meta = with stdenv.lib; {
    description = "bcrypt password hashing and key derivation";
    homepage = https://code.google.com/p/py-bcrypt2;
    license = licenses.bsd0;
  };

}
