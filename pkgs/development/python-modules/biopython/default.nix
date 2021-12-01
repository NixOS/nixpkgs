{ lib
, buildPythonPackage
, fetchPypi
, numpy
, isPy3k
}:

buildPythonPackage rec {
  pname = "biopython";
  version = "1.79";

  src = fetchPypi {
    inherit pname version;
    sha256 = "edb07eac99d3b8abd7ba56ff4bedec9263f76dfc3c3f450e7d2e2bcdecf8559b";
  };

  disabled = !isPy3k;

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
    homepage = "https://biopython.org/wiki/Documentation";
    maintainers = with lib.maintainers; [ luispedro ];
    license = lib.licenses.bsd3;
  };
}
