{ lib
, buildPythonPackage
, fetchPypi
, numpy
}:

buildPythonPackage rec {
  pname = "biopython";
  version = "1.68";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07qc7nz0k77y8hf8s18rscvibvm91zw0kkq7ylrhisf8vp8hkp6i";
  };

  propagatedBuildInputs = [ numpy ];
  # Checks try to write to $HOME, which does not work with nix
  doCheck = false;
  meta = {
    description = "Python library for bioinformatics";
    longDescription = ''
      Biopython is a set of freely available tools for biological computation
      written in Python by an international team of developers. It is a
      distributed collaborative effort to develop Python libraries and
      applications which address the needs of current and future work in
      bioinformatics.
    '';
    homepage = http://biopython.org/wiki/Documentation;
    maintainers = with lib.maintainers; [ luispedro ];
    license = lib.licenses.bsd3;
  };
}