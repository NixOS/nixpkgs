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
, semantic-version
, sphinx
}:

buildPythonPackage rec {
  pname = "releases";
  version = "1.6.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bitprophet";
    repo = pname;
    rev = version;
    hash = "sha256-XX2e6bjBNMun31h0sNJ9ieZE01U+PhA5JYYNOuMgD20=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "semantic_version<2.7" "semantic_version"
  '';

  propagatedBuildInputs = [ semantic-version sphinx ];

  # Test suite doesn't run. See https://github.com/bitprophet/releases/issues/95.
  doCheck = false;

  pythonImportsCheck = [ "releases" ];

  meta = with lib; {
    description = "A Sphinx extension for changelog manipulation";
    homepage = "https://github.com/bitprophet/releases";
    license = licenses.bsd2;
    maintainers = with maintainers; [ samuela ];
  };
}
