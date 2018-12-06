{ stdenv
, buildPythonPackage
, fetchPypi
, unittest2
, pyasn1
}:

buildPythonPackage rec {
  pname = "rsa";
  version = "3.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dcxvszbikgzh99ybdc7jq0zb9wspy2ds8z9mjsqiyv3q884xpr5";
  };

  nativeBuildInputs = [ unittest2 ];
  propagatedBuildInputs = [ pyasn1 ];

  meta = with stdenv.lib; {
    homepage = https://stuvel.eu/rsa;
    license = licenses.asl20;
    description = "A pure-Python RSA implementation";
  };

}
