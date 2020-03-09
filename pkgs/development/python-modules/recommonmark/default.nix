{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, CommonMark
, docutils
, sphinx
}:

buildPythonPackage rec {
  pname = "recommonmark";
  version = "0.6.0";

  # PyPI tarball is missing some test files: https://github.com/rtfd/recommonmark/pull/128
  src = fetchFromGitHub {
    owner = "rtfd";
    repo = pname;
    rev = version;
    sha256 = "0m6qk17irka448vcz5b39yck1qsq90k98dmkx80mni0w00yq9ggd";
  };

  checkInputs = [ pytestCheckHook ];
  propagatedBuildInputs = [ CommonMark docutils sphinx ];

  dontUseSetuptoolsCheck = true;

  disabledTests = [
    # https://github.com/readthedocs/recommonmark/issues/164
    "test_lists"
    "test_integration"
  ];

  meta = {
    description = "A docutils-compatibility bridge to CommonMark";
    homepage = https://github.com/rtfd/recommonmark;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
