{ lib
, buildPythonPackage
, isPy3k
, fetchFromGitHub
, dateutil
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
    dateutil pytz regex tzlocal
    # extra_requires
    hijri-converter convertdate
  ];

  checkInputs = [
    parameterized
    pytestCheckHook
    GitPython
    ruamel_yaml
  ];


  pytestFlagsArray = [

    # parallel testing leads to failure
    "-n" "0"

    # Upstream only runs the tests in tests/ in CI, others use git clone
    "tests"
  ];

  pythonImportsCheck = [ "dateparser" ];

  meta = with lib; {
    description = "Date parsing library designed to parse dates from HTML pages";
    homepage = "https://github.com/scrapinghub/dateparser";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
