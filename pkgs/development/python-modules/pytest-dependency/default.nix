{ stdenv, buildPythonPackage, fetchPypi, fetchpatch, pytest }:

buildPythonPackage rec {
  version = "0.5.1";
  pname = "pytest-dependency";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c2a892906192663f85030a6ab91304e508e546cddfe557d692d61ec57a1d946b";
  };

  propagatedBuildInputs = [ pytest ];

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/RKrahl/pytest-dependency";
    description = "Manage dependencies of tests";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
