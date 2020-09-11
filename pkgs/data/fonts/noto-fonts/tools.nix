{ fetchFromGitHub, lib, buildPythonPackage, pythonOlder
, afdko, appdirs, attrs, black, booleanoperations, brotlipy, click
, defcon, fontmath, fontparts, fontpens, fonttools, fs, lxml
, mutatormath, pathspec, psautohint, pyclipper, pytz, regex, scour
, toml, typed-ast, ufonormalizer, ufoprocessor, unicodedata2, zopfli
, pillow, six, bash, setuptools_scm }:

buildPythonPackage rec {
  pname = "nototools";
  version = "0.2.12";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "nototools";
    rev = "v${version}";
    sha256 = "0drmx1asni3g6616fa4gjn5n43qkcf7icvxq9y2krpjxq78wcmc5";
  };

  postPatch = ''
    sed -i 's/use_scm_version=.*,/version="${version}",/' setup.py
  '';

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [
    afdko
    appdirs
    attrs
    black
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

  meta = {
    description = "Noto fonts support tools and scripts plus web site generation";
    license = lib.licenses.asl20;
    homepage = "https://github.com/googlefonts/nototools";
  };
}
