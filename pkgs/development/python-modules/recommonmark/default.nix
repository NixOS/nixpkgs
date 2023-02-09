{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, CommonMark
, docutils
, sphinx
, isPy3k
}:

buildPythonPackage rec {
  pname = "recommonmark";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "rtfd";
    repo = pname;
    rev = version;
    sha256 = "0kwm4smxbgq0c0ybkxfvlgrfb3gq9amdw94141jyykk9mmz38379";
  };

  nativeCheckInputs = [ pytestCheckHook ];
  propagatedBuildInputs = [ CommonMark docutils sphinx ];

  dontUseSetuptoolsCheck = true;

  disabledTests = [
    # https://github.com/readthedocs/recommonmark/issues/164
    "test_lists"
    "test_integration"
  ];

  doCheck = !isPy3k; # Not yet compatible with latest Sphinx.
  pythonImportsCheck = [ "recommonmark" ];

  meta = {
    description = "A docutils-compatibility bridge to CommonMark";
    homepage = "https://github.com/rtfd/recommonmark";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
