{
  stdenv,
  lib,
  fetchPypi,
  buildPythonPackage,
  pytest,
  numpy,
  cython,
}:

buildPythonPackage rec {
  pname = "imagecodecs-lite";
  version = "2019.12.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ldGKoTzrGximEJQztC0FThO5opXLqWwIq3Gfhk9YnWg=";
  };

  nativeBuildInputs = [ cython ];

  nativeCheckInputs = [ pytest ];

  propagatedBuildInputs = [ numpy ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Block-oriented, in-memory buffer transformation, compression, and decompression functions";
    homepage = "https://www.lfd.uci.edu/~gohlke/";
    maintainers = [ maintainers.tbenst ];
    license = licenses.bsd3;
  };
}
