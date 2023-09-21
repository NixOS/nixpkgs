{ lib
, babel
, buildPythonPackage
, cssselect
, fetchFromGitHub
, glibcLocales
, isodate
, leather
, lxml
, nose
, parsedatetime
, pyicu
, python-slugify
, pytimeparse
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "agate";
  version = "1.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "wireservice";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-7Ew9bgeheymCL8xXSW5li0LdFvGYb/7gPxmC4w6tHvM=";
  };

  propagatedBuildInputs = [
    babel
    isodate
    leather
    parsedatetime
    python-slugify
    pytimeparse
  ];

  nativeCheckInputs = [
    cssselect
    glibcLocales
    lxml
    nose
    pyicu
    pytz
  ];

  checkPhase = ''
    LC_ALL="en_US.UTF-8" nosetests tests
  '';

  pythonImportsCheck = [
    "agate"
  ];

  meta = with lib; {
    description = "Python data analysis library that is optimized for humans instead of machines";
    homepage = "https://github.com/wireservice/agate";
    changelog = "https://github.com/wireservice/agate/blob/${version}/CHANGELOG.rst";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ vrthra ];
  };
}
