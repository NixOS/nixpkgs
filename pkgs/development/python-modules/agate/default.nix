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
, six
}:

buildPythonPackage rec {
  pname = "agate";
  version = "1.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "wireservice";
    repo = pname;
    rev = version;
    hash = "sha256-7Ew9bgeheymCL8xXSW5li0LdFvGYb/7gPxmC4w6tHvM=";
  };

  propagatedBuildInputs = [
    babel
    isodate
    leather
    parsedatetime
    python-slugify
    pytimeparse
    six
  ];

  nativeCheckInputs = [
    cssselect
    glibcLocales
    lxml
    nose
    pyicu
    pytz
  ];

  postPatch = ''
    # No Python 2 support, thus constraint is not needed
    substituteInPlace setup.py \
      --replace "'parsedatetime>=2.1,!=2.5,!=2.6'," "'parsedatetime>=2.1',"
  '';

  checkPhase = ''
    LC_ALL="en_US.UTF-8" nosetests tests
  '';

  pythonImportsCheck = [
    "agate"
  ];

  meta = with lib; {
    description = "Python data analysis library that is optimized for humans instead of machines";
    homepage = "https://github.com/wireservice/agate";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ vrthra ];
  };
}
