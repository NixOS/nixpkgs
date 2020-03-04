{ buildPythonPackage, fetchPypi, atpublic }:

buildPythonPackage rec {
  pname = "flufl.lock";
  version = "3.2";

  propagatedBuildInputs = [ atpublic ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nzzd6l30ff6cwsrlrb94xzfja4wkyrqv3ydc6cz0hdbr766mmm8";
  };
}
