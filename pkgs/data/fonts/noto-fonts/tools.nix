{ fetchFromGitHub, lib, buildPythonPackage, pythonOlder
, afdko, appdirs, attrs, booleanoperations, brotlipy, click
, defcon, fontmath, fontparts, fontpens, fonttools, lxml
, mutatormath, pathspec, psautohint, pyclipper, pytz, regex, scour
, toml, typed-ast, ufonormalizer, ufoprocessor, unicodedata2, zopfli
, pillow, six, bash, setuptools-scm }:

buildPythonPackage rec {
  pname = "nototools";
  version = "0.2.17";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "nototools";
    rev = "v${version}";
    sha256 = "0jxydivqzggirc31jv7b4mrsjkg646zmra5m4h0pk4amgy65rvyp";
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

  nativeCheckInputs = [
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
