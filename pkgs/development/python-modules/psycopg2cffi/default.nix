{ buildPythonPackage, cffi, fetchFromGitHub, lib, postgresql, pytestCheckHook, six }:

buildPythonPackage rec {
  pname = "psycopg2cffi";
  version = "2.8.1";
  format = "setuptools";

  # NB: This is a fork.
  # The original repo exists at https://github.com/chtd/psycopg2cffi, however
  # this is mostly unmaintained and does not build for PyPy. Given that the
  # whole point of this cffi alternative to psycopg2 is to use it with PyPy, I
  # chose to use a working fork instead, which was linked in the relevant issue:
  # https://github.com/chtd/psycopg2cffi/issues/113#issuecomment-730548574
  #
  # If/when these changes get merged back upstream we should revert to using the
  # original source as opposed to the fork.
  src = fetchFromGitHub {
    owner = "Omegapol";
    repo = pname;
    rev = "c202b25cd861d5e8f0f55c329764ff1da9f020c0";
    sha256 = "09hsnjkix1c0vlhmfvrp8pchpnz2ya4xrchyq15czj527nx2dmy2";
  };

  nativeBuildInputs = [ postgresql ];
  propagatedBuildInputs = [ six cffi ];
  nativeCheckInputs = [ pytestCheckHook ];

  # NB: The tests need a postgres instance running to test against, and so we
  # disable them.
  doCheck = false;

  pythonImportsCheck = [ "psycopg2cffi" ];

  meta = with lib; {
    description = "An implementation of the psycopg2 module using cffi";
    homepage = "https://pypi.org/project/psycopg2cffi/";
    license = with licenses; [ lgpl3Plus ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}
