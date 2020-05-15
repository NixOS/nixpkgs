{ stdenv, buildPythonPackage, fetchPypi, numpy, pandas, pysam, six,
  pytest, numpydoc, pathlib, psutil, pyyaml, sphinx, zlib
}:
buildPythonPackage rec {
  version = "0.8.1";
  pname = "pybedtools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c035e078617f94720eb627e20c91f2377a7bd9158a137872a6ac88f800898593";
  };

  checkInputs = [ pytest numpydoc pathlib psutil pyyaml sphinx ];
  propagatedBuildInputs = [ numpy pandas pysam six zlib ];

  checkPhase = ''
    pytest -v -doctest-modules
  '';

  # Tests require extra dependencies
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/daler/pybedtools";
    description = "Python wrapper -- and more -- for Aaron Quinlan's BEDTools (bioinformatics tools) http://daler.github.io/pybedtools";
    license = licenses.gpl2;
  };
}
