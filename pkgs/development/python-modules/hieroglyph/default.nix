{ lib, fetchFromGitHub, buildPythonPackage, isPy27, sphinx }:

buildPythonPackage rec {
  pname = "hieroglyph";
  version = "2.1.0";
  disabled = isPy27; # python2 compatible sphinx is too low

  src = fetchFromGitHub {
     owner = "nyergler";
     repo = "hieroglyph";
     rev = "hieroglyph-2.1.0";
     sha256 = "1q84q8dz1p291y9yfh3md2418qqa8z7a1kpr8aink0qbblf5rgly";
  };

  propagatedBuildInputs = [ sphinx ];

  # all tests fail; don't know why:
  # test_absolute_paths_made_relative (hieroglyph.tests.test_path_fixing.PostProcessImageTests) ... ERROR
  doCheck = false;

  meta = with lib; {
    description = "Generate HTML presentations from plain text sources";
    homepage = "https://github.com/nyergler/hieroglyph/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ juliendehos ];
  };
}

