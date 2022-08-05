################################################################################
# WARNING: Changes made to this file MUST go through the usual PR review process
#          and MUST be approved by a member of `meta.maintainers` before
#          merging. Commits attempting to circumvent the PR review process -- as
#          part of python-updates or otheriwse -- will be reverted without
#          notice.
################################################################################
{ buildPythonPackage
, fetchFromGitHub
, lib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "in-place";
  version = "0.5.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jwodder";
    repo = "inplace";
    rev = "v${version}";
    sha256 = "1w6q3d0gqz4mxvspd08l1nhsrw6rpzv1gnyj4ckx61b24f84p5gk";
  };

  postPatch = ''
    substituteInPlace tox.ini --replace "--cov=in_place --no-cov-on-fail" ""
  '';

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "in_place" ];

  meta = with lib; {
    description = "In-place file processing";
    homepage = "https://github.com/jwodder/inplace";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
