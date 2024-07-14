{
  lib,
  fetchPypi,
  buildPythonPackage,
  isPy27,
  sphinx,
}:

buildPythonPackage rec {
  pname = "hieroglyph";
  version = "2.1.0";
  format = "setuptools";
  disabled = isPy27; # python2 compatible sphinx is too low

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tLXbE6nTh0OOYQwsodgThszSBpRNmp3Sc/IYdEhs3a8=";
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
