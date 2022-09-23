{ fetchFromGitHub, lib, buildPythonPackage, pythonOlder
, afdko, appdirs, attrs, booleanoperations, brotlipy, click
, defcon, fontmath, fontparts, fontpens, fonttools, lxml
, mutatormath, pathspec, psautohint, pyclipper, pytz, regex, scour
, toml, typed-ast, ufonormalizer, ufoprocessor, unicodedata2, zopfli
, pillow, six, bash, setuptools-scm }:

buildPythonPackage rec {
  pname = "nototools";
  version = "0.2.16";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "nototools";
    rev = "v${version}";
    sha256 = "14rrdamkmhrykff8ln07fq9cm8zwj3k113lzwjcy0lgz23g51jyl";
  };

  postPatch = ''
    sed -i 's/use_scm_version=.*,/version="${version}",/' setup.py
  '';

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    afdko
    appdirs
    attrs
    booleanoperations
    brotlipy
    click
    defcon
    fontmath
    fontparts
    fontpens
    fonttools
    lxml
    mutatormath
    pathspec
    psautohint
    pyclipper
    pytz
    regex
    scour
    toml
    typed-ast
    ufonormalizer
    ufoprocessor
    unicodedata2
    zopfli
  ];

  checkInputs = [
    pillow
    six
    bash
  ];

  checkPhase = ''
    patchShebangs tests/
    cd tests
    rm gpos_diff_test.py # needs ttxn?
    ./run_tests
  '';

  postInstall = ''
    cp -r third_party $out
  '';

  meta = with lib; {
    description = "Noto fonts support tools and scripts plus web site generation";
    homepage = "https://github.com/googlefonts/nototools";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
