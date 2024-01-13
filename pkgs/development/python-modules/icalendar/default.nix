{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, backports-zoneinfo
, python-dateutil
, pytz
, hypothesis
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "5.0.10";
  pname = "icalendar";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "collective";
    repo = "icalendar";
    rev = "refs/tags/v${version}";
    hash = "sha256-sRsUjNClJ58kmCRiwSe7oq20eamj95Vwy/o0xPU8qPw=";
  };

  propagatedBuildInputs = [
    python-dateutil
    pytz
  ] ++ lib.optionals (pythonOlder "3.9") [
    backports-zoneinfo
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pytestFlagsArray = [ "src/icalendar" ];

  meta = with lib; {
    changelog = "https://github.com/collective/icalendar/blob/v${version}/CHANGES.rst";
    description = "A parser/generator of iCalendar files";
    homepage = "https://github.com/collective/icalendar";
    license = licenses.bsd2;
    maintainers = with maintainers; [ olcai ];
  };

}
