{
  lib,
  buildPythonPackage,
  fetchPypi,

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
  version = "4.13.4";
  pyproject = true;

  outputs = [
    "out"
    "doc"
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-27PE4c6uau/r2vJCMkcmDNBiQwpBDjjGbyuqUKhDcZU=";
  };

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
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

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

  meta = with lib; {
    changelog = "https://git.launchpad.net/beautifulsoup/tree/CHANGELOG?h=${version}";
    description = "HTML and XML parser";
    homepage = "http://crummy.com/software/BeautifulSoup/bs4/";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };
}
