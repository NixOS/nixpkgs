{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,

  # build-system
  hatchling,

  # docs
  sphinxHook,

  # dependencies
  soupsieve,
  typing-extensions,

  # optional-dependencies
  chardet,
  charset-normalizer,
  faust-cchardet,
  html5lib,
  lxml,

  # tests
  pytestCheckHook,

  # for passthru.tests
  html-sanitizer,
  markdownify,
  mechanicalsoup,
  nbconvert,
  subliminal,
  wagtail,
}:

buildPythonPackage rec {
  pname = "beautifulsoup4";
<<<<<<< HEAD
  version = "4.14.3";
=======
  version = "4.13.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  outputs = [
    "out"
    "doc"
  ];

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-YpKxxRhtNWu6Zp759/BRdXCZVlrZraXdYwvZ3l+n+4Y=";
  };

  patches = [
    # Fix tests with python 3.13.10 / 3.14.1
    (fetchpatch {
      url = "https://git.launchpad.net/beautifulsoup/patch/?id=55f655ffb7ef03bdd1df0f013743831fe54e3c7a";
      excludes = [ "CHANGELOG" ];
      hash = "sha256-DJl1pey0NdJH+SyBH9+y6gwUvQCmou0D9xcRAEV8OBw=";
=======
    hash = "sha256-27PE4c6uau/r2vJCMkcmDNBiQwpBDjjGbyuqUKhDcZU=";
  };

  patches = [
    # backport test fix for behavior changes in libxml 2.14.3
    (fetchpatch {
      url = "https://git.launchpad.net/beautifulsoup/patch/?id=53d328406ec8c37c0edbd00ace3782be63e2e7e5";
      excludes = [ "CHANGELOG" ];
      hash = "sha256-RtavbpnfT6x0A8L3tAvCXwKUpty1ASPGJKdks7evBr8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    })
  ];

  build-system = [ hatchling ];

  nativeBuildInputs = [ sphinxHook ];

  dependencies = [
    soupsieve
    typing-extensions
  ];

  optional-dependencies = {
    chardet = [ chardet ];
    cchardet = [ faust-cchardet ];
    charset-normalizer = [ charset-normalizer ];
    html5lib = [ html5lib ];
    lxml = [ lxml ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (lib.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  disabledTests = [
    # fail with latest libxml, by not actually rejecting
    "test_rejected_markup"
    "test_rejected_input"
  ];

  pythonImportsCheck = [ "bs4" ];

  passthru.tests = {
    inherit
      html-sanitizer
      markdownify
      mechanicalsoup
      nbconvert
      subliminal
      wagtail
      ;
  };

<<<<<<< HEAD
  meta = {
    changelog = "https://git.launchpad.net/beautifulsoup/tree/CHANGELOG?h=${version}";
    description = "HTML and XML parser";
    homepage = "http://crummy.com/software/BeautifulSoup/bs4/";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    changelog = "https://git.launchpad.net/beautifulsoup/tree/CHANGELOG?h=${version}";
    description = "HTML and XML parser";
    homepage = "http://crummy.com/software/BeautifulSoup/bs4/";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
