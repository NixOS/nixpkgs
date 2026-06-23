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
  version = "4.14.3";
  pyproject = true;

  outputs = [
    "out"
    "doc"
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YpKxxRhtNWu6Zp759/BRdXCZVlrZraXdYwvZ3l+n+4Y=";
  };

  patches = [
    # Fix tests with python 3.13.10 / 3.14.1
    (fetchpatch {
      url = "https://git.launchpad.net/beautifulsoup/patch/?id=55f655ffb7ef03bdd1df0f013743831fe54e3c7a";
      excludes = [ "CHANGELOG" ];
      hash = "sha256-DJl1pey0NdJH+SyBH9+y6gwUvQCmou0D9xcRAEV8OBw=";
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
  ++ lib.concatAttrValues optional-dependencies;

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

  meta = {
    changelog = "https://git.launchpad.net/beautifulsoup/tree/CHANGELOG?h=${version}";
    description = "HTML and XML parser";
    homepage = "http://crummy.com/software/BeautifulSoup/bs4/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
