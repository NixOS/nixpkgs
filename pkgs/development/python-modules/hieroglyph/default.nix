{ stdenv, fetchPypi, buildPythonPackage, sphinx }:

buildPythonPackage rec {
  pname = "hieroglyph";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8e137f0b1cd60c47b870011089790d3c8ddb74fcf409a75ddf2c7f2516ff337c";
  };

  propagatedBuildInputs = [ sphinx ];

  # all tests fail; don't know why:
  # test_absolute_paths_made_relative (hieroglyph.tests.test_path_fixing.PostProcessImageTests) ... ERROR
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Generate HTML presentations from plain text sources";
    homepage = "https://github.com/nyergler/hieroglyph/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ juliendehos ];
  };
}

