{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  chardet,
  hatchling,
  html5lib,
  lxml,
  pytestCheckHook,
  pythonOlder,
  soupsieve,
  sphinxHook,

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
  version = "4.12.3";
  pyproject = true;

  outputs = [
    "out"
    "doc"
  ];

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dOPRko7cBw0hdIGFxG4/szSQ8i9So63e6a7g9Pd4EFE=";
  };

  patches = [
    (fetchpatch {
      name = "tests.patch";
      url = "https://git.launchpad.net/beautifulsoup/patch/?id=9786a62726de5a8caba10021c4d4a58c8a3e9e3f";
      hash = "sha256-FOMoJjT0RgqKjbTLN/qCuc0HjhKeenMcgwb9Fp8atAY=";
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

  optional-dependencies = {
    html5lib = [ html5lib ];
    lxml = [ lxml ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

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
