{ stdenv, fetchFromGitHub, buildPythonPackage, isPy3k
, nose
, nose-parameterized
, mock
, glibcLocales
, six
, jdatetime
, pyyaml
, dateutil
, umalqurra
, pytz
, tzlocal
, regex
, ruamel_yaml }:
buildPythonPackage rec {
  pname = "dateparser";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "scrapinghub";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "0q2vyzvlj46r6pr0s6m1a0md1cpg9nv1n3xw286l4x2cc7fj2g3y";
  };

  # Upstream Issue: https://github.com/scrapinghub/dateparser/issues/364
  disabled = isPy3k;

  checkInputs = [ nose nose-parameterized mock glibcLocales ];
  preCheck =''
    # skip because of missing convertdate module, which is an extra requirement
    rm tests/test_jalali.py
  '';

  propagatedBuildInputs = [ six jdatetime pyyaml dateutil
            umalqurra pytz tzlocal regex ruamel_yaml ];

  meta = with stdenv.lib;{
    description = "Date parsing library designed to parse dates from HTML pages";
    homepage = https://github.com/scrapinghub/dateparser;
    license = licenses.bsd3;
  };
}
