################################################################################
# WARNING: Changes made to this file MUST go through the usual PR review process
#          and MUST be approved by a member of `meta.maintainers` before
#          merging. Commits attempting to circumvent the PR review process -- as
#          part of python-updates or otheriwse -- will be reverted without
#          notice.
################################################################################
{ buildPythonPackage
, docopt
, fastavro
, fetchFromGitHub
, lib
, nose
, pytestCheckHook
, requests
, six
}:

buildPythonPackage rec {
  pname = "hdfs";
  # See https://github.com/mtth/hdfs/issues/176.
  version = "2.5.8";

  src = fetchFromGitHub {
    owner = "mtth";
    repo = pname;
    rev = version;
    hash = "sha256-94Q3IUoX1Cb+uRqvsfpVZJ1koJSx5cQ3/XpYJ0gkQNU=";
  };

  propagatedBuildInputs = [ docopt requests six ];

  checkInputs = [ fastavro nose pytestCheckHook ];

  pythonImportsCheck = [ "hdfs" ];

  meta = with lib; {
    description = "Python API and command line interface for HDFS";
    homepage = "https://github.com/mtth/hdfs";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
