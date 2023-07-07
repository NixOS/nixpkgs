{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, pythonOlder
}:

if !(pythonOlder "3.3") then null else buildPythonPackage {
  pname = "backports.shutil_get_terminal_size";
  version = "unstable-2016-02-21";

  # there have been numerous fixes committed since the initial release.
  # Most notably fixing a problem where the backport would always return
  # terminal size 0. See https://trac.sagemath.org/ticket/25320#comment:5.
  # Unfortunately the maintainer seems inactive and has not responded to
  # a request for a new release since 2016:
  # https://github.com/chrippa/backports.shutil_get_terminal_size/issues/7
  src = fetchFromGitHub {
    owner = "chrippa";
    repo = "backports.shutil_get_terminal_size";
    rev = "159e269450dbf37c3a837f6ea7e628d59acbb96a";
    sha256 = "17sgv8vg0xxfdnca45l1mmwwvj29gich5c8kqznnj51kfccch7sg";
  };

  nativeCheckInputs = [
    pytest
  ];

  meta = with lib; {
    description = "A backport of the get_terminal_size function from Python 3.3’s shutil.";
    homepage = "https://github.com/chrippa/backports.shutil_get_terminal_size";
    license = with licenses; [ mit ];
    maintainers = teams.sage.members;
  };
}
