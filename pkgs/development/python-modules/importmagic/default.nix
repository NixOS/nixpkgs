{ stdenv
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "importmagic";
  version = "0.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "194bl8l8sc2ibwi6g5kz6xydkbngdqpaj6r2gcsaw1fc73iswwrj";
  };

  propagatedBuildInputs = [ six ];

  doCheck = false;  # missing json file from tarball

  meta = with stdenv.lib; {
    description = "Python Import Magic - automagically add, remove and manage imports";
    homepage = https://github.com/alecthomas/importmagic;
    license = licenses.bsd0;
  };

}
