{ stdenv, lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "Durus";
  version = "4.2";

  src = fetchPypi {
    inherit version pname;
    sha256 = "sha256:1gzxg43zawwgqjrfixvcrilwpikb1ix9b7710rsl5ffk7q50yi3c";
  };

  nativeBuildInputs = [ ];
  buildInputs = [  ];

  # Checks disabled due to the fact that this needs a
  # python unittest framework called 'sancho' which is not
  # covered in nixpkgs yet.
  doCheck = false;

  meta = with lib; {
    description = "A python object persistence layer";
    homepage = "https://github.com/nascheme/durus";
    license = licenses.mit;
    maintainers = with maintainers; [ grindhold ];
  };
}
