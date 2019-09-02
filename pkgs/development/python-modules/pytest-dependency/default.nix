{ stdenv, buildPythonPackage, fetchPypi, fetchpatch, pytest }:

buildPythonPackage rec {
  version = "0.4.0";
  pname = "pytest-dependency";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bda0ef48e6a44c091399b12ab4a7e580d2dd8294c222b301f88d7d57f47ba142";
  };

  patches = [
    # Fix tests for pytest>=4.2.0. Remove with the next release
    (fetchpatch {
      url = "https://github.com/RKrahl/pytest-dependency/commit/089395bf77e629ee789666361ee12395d840252c.patch";
      sha256 = "1nkha2gndrr3mx11kx2ipxhphqd6wr25hvkrfwzyrispqfhgl0wm";
      excludes = [ "doc/src/changelog.rst" ];
    })
  ];

  propagatedBuildInputs = [ pytest ];

  checkInputs = [ pytest ];

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
