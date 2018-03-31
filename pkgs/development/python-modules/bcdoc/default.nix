{ stdenv, buildPythonPackage, fetchPypi, docutils, six }:

buildPythonPackage rec {
  pname = "bcdoc";
  version = "0.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1s2kdqs1n2mj7wq3w0pq30zs7vxq0l3abik2clqnc4hm2j7crbk8";
  };

  buildInputs = [ docutils six ];

  # Tests fail due to nix file timestamp normalization.
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/botocore/bcdoc;
    license = licenses.asl20;
    description = "ReST document generation tools for botocore";
  };
}
