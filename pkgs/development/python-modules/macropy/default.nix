{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, isPy27
, pythonAtLeast
, pinqSupport ? false, sqlalchemy
, pyxlSupport ? false, pyxl3
}:

buildPythonPackage rec {
  # https://github.com/lihaoyi/macropy/issues/94
  version = "1.1.0b2";
  format = "setuptools";
  pname = "macropy";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "lihaoyi";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bd2fzpa30ddva3f8lw2sbixxf069idwib8srd64s5v46ricm2cf";
  };

  # js_snippets extra only works with python2
  propagatedBuildInputs = [ ]
    ++ lib.optional pinqSupport sqlalchemy
    ++ lib.optional pyxlSupport pyxl3;

  checkPhase = ''
    ${python.interpreter} run_tests.py
  '';

  meta = with lib; {
    homepage = "https://github.com/lihaoyi/macropy";
    description = "Macros in Python: quasiquotes, case classes, LINQ and more";
    license = licenses.mit;
    maintainers = [ ];
    broken = pythonAtLeast "3.8"; # see https://github.com/lihaoyi/macropy/issues/103
  };
}
