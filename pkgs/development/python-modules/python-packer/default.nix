{ stdenv, buildPythonPackage, fetchPypi, sh }:

buildPythonPackage rec {
  pname = "python-packer";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fd363dae9bd2efd447739bbf7a4f29c1e4741596ae7b02d252fe525b2b4176e7";
  };

  propagatedBuildInputs = [ sh ];
  
  # Tests requires network connections
  doCheck = false;
  
  meta = with stdenv.lib; {
    description = "An interface for packer.io";
    homepage = https://github.com/nir0s/python-packer;
    license = licenses.asl20;
    maintainers = with maintainers; [ psyanticy ];
  };
}

