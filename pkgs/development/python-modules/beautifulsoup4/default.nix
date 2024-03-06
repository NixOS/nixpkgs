{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, chardet
, hatchling
, html5lib
, lxml
, pytestCheckHook
, pythonOlder
, soupsieve
, sphinxHook

# for passthru.tests
, html-sanitizer
, markdownify
, mechanicalsoup
, nbconvert
, subliminal
, wagtail
}:

buildPythonPackage rec {
  pname = "beautifulsoup4";
  version = "4.12.2";
  format = "pyproject";

  outputs = ["out" "doc"];

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SSu8adyjXRLarHHE2xv/8Mh2wA70ov+sziJtRjjrcto=";
  };

  patches = [
    # Fix test with libxml 2.12.
    # https://bugs.launchpad.net/beautifulsoup/+bug/2045481
    (fetchpatch {
      url = "https://bugs.launchpad.net/beautifulsoup/+bug/2045481/+attachment/5726132/+files/2045481.diff";
      hash = "sha256-f/Wkh7El4r1iWM2/CSi5AKE1+NsEP3D5pxWgBcZ//Vs=";
      excludes = [
        "CHANGELOG"
      ];
    })
  ];

  nativeBuildInputs = [
    hatchling
    sphinxHook
  ];

  propagatedBuildInputs = [
    chardet
    soupsieve
  ];

  passthru.optional-dependencies = {
    html5lib = [
      html5lib
    ];
    lxml = [
      lxml
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "bs4"
  ];

  passthru.tests = {
    inherit html-sanitizer
      markdownify
      mechanicalsoup
      nbconvert
      subliminal
      wagtail;
  };

  meta = with lib; {
    changelog = "https://git.launchpad.net/beautifulsoup/tree/CHANGELOG?h=${version}";
    description = "HTML and XML parser";
    homepage = "http://crummy.com/software/BeautifulSoup/bs4/";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };
}
