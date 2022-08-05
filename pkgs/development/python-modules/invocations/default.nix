################################################################################
# WARNING: Changes made to this file MUST go through the usual PR review process
#          and MUST be approved by a member of `meta.maintainers` before
#          merging. Commits attempting to circumvent the PR review process -- as
#          part of python-updates or otheriwse -- will be reverted without
#          notice.
################################################################################
{ lib
, buildPythonPackage
, blessings
, fetchFromGitHub
, invoke
, releases
, semantic-version
, tabulate
, tqdm
, twine
}:

buildPythonPackage rec {
  pname = "invocations";
  version = "2.6.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pyinvoke";
    repo = pname;
    rev = version;
    hash = "sha256-eyOJKVRfn7elyEkERl7hvRTNFmq7O9Pr03lBS6xp0wE=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "semantic_version>=2.4,<2.7" "semantic_version" \
      --replace "tabulate==0.7.5" "tabulate"
  '';

  propagatedBuildInputs = [
    blessings
    invoke
    releases
    semantic-version
    tabulate
    tqdm
    twine
  ];

  # There's an error loading the test suite. See https://github.com/pyinvoke/invocations/issues/29.
  doCheck = false;

  pythonImportsCheck = [
    "invocations"
  ];

  meta = with lib; {
    description = "Common/best-practice Invoke tasks and collections";
    homepage = "https://invocations.readthedocs.io/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ samuela ];
  };
}
