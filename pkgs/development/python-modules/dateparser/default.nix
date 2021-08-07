{ lib
, buildPythonPackage
, isPy3k
, fetchFromGitHub
, python-dateutil
, pytz
, regex
, tzlocal
, hijri-converter
, convertdate
, parameterized
, pytestCheckHook
, GitPython
, ruamel_yaml
}:

buildPythonPackage rec {
  pname = "dateparser";
  version = "1.0.0";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "scrapinghub";
    repo = "dateparser";
    rev = "v${version}";
    sha256 = "0i6ci14lqfsqrmaif57dyilrjbxzmbl98hps1b565gkiy1xqmjhl";
  };

  propagatedBuildInputs = [
    # install_requires
    python-dateutil pytz regex tzlocal
    # extra_requires
    hijri-converter convertdate
  ];

  checkInputs = [
    parameterized
    pytestCheckHook
    GitPython
    ruamel_yaml
  ];

  # Upstream only runs the tests in tests/ in CI, others use git clone
  pytestFlagsArray = [ "tests" ];

  pythonImportsCheck = [ "dateparser" ];

  meta = with lib; {
    description = "Date parsing library designed to parse dates from HTML pages";
    homepage = "https://github.com/scrapinghub/dateparser";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
