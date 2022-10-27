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
, PyICU
, python-slugify
, pytimeparse
, pythonOlder
, pytz
, six
}:

buildPythonPackage rec {
  pname = "agate";
  version = "1.6.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "wireservice";
    repo = pname;
    rev = version;
    sha256 = "sha256-tuUoLvztCYHIPJTBgw1eByM0zfaHDyc+h7SWsxutKos=";
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

  checkInputs = [
    cssselect
    glibcLocales
    lxml
    nose
    PyICU
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
