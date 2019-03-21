{ stdenv, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  version = "0.4.0";
  pname = "pytest-dependency";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bda0ef48e6a44c091399b12ab4a7e580d2dd8294c222b301f88d7d57f47ba142";
  };

  propagatedBuildInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/RKrahl/pytest-dependency;
    description = "Manage dependencies of tests";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
