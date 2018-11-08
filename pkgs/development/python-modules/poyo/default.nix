{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "0.4.2";
  pname = "poyo";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07fdxlqgnnzb8r6lasvdfjcbd8sb9af0wla08rbfs40j349m8jn3";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/hackebrot/poyo;
    description = "A lightweight YAML Parser for Python";
    license = licenses.mit;
  };

}
