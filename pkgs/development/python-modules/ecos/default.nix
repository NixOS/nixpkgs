{ buildPythonPackage, fetchPypi, lib, numpy, scipy, nose }:

buildPythonPackage rec {
  pname = "ecos";
  version = "2.0.7.post1";

  propagatedBuildInputs = [
    numpy
    scipy
  ];
  checkInputs = [ nose ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0n67plhclbsxqi23is8rj62vv3d75nnwzhsmya9jlbpknd10zsc3";
  };

  meta = {
    description = "This is the Python package for ECOS: Embedded Cone Solver";
    homepage = https://github.com/embotech/ecos;
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.teh ];
  };
}
