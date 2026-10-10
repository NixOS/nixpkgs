{
  lib,
  buildPythonPackage,
  fetchPypi,
  defusedxml,
  pytest,
}:

buildPythonPackage rec {
  pname = "odfpy";
  version = "1.4.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-23ZqblnFEDIS88yS7I3VCg86AnkCM+0LUhSLcNPEOOw=";
  };

  propagatedBuildInputs = [ defusedxml ];

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

  meta = {
    description = "Python API and tools to manipulate OpenDocument files";
    homepage = "https://github.com/eea/odfpy";
    license = lib.licenses.asl20;
  };
}
