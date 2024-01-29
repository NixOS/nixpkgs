{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "imagesize";
  version = "1.4.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aRUERK/7nLDVzFqSs2dvCy+3zZrjnpR6XhGja0SXzUo=";
  };

  meta = with lib; {
    description = "Getting image size from png/jpeg/jpeg2000/gif file";
    homepage = "https://github.com/shibukawa/imagesize_py";
    license = with licenses; [ mit ];
  };

}
