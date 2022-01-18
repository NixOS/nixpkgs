{ lib
, beautifulsoup4
, blinker
, buildPythonPackage
, docutils
, feedgenerator
, fetchFromGitHub
, git
, glibcLocales
, jinja2
, lxml
, markdown
, markupsafe
, mock
, pytestCheckHook
, pandoc
, pillow
, pygments
, python-dateutil
, pythonOlder
, pytz
, rich
, pytest-xdist
, six
, typogrify
, unidecode
}:

buildPythonPackage rec {
  pname = "pelican";
  version = "4.7.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "getpelican";
    repo = pname;
    rev = version;
    sha256 = "0w3r4ifbrl6mhfphabqs048qys7x6k164ds63jr10l3namljm8ad";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    extraPostFetch = ''
      rm -r $out/pelican/tests/output/custom_locale/posts
    '';
  };

  buildInputs = [
    glibcLocales
    pandoc
    git
    mock
    markdown
    typogrify
  ];

  propagatedBuildInputs = [
    beautifulsoup4
    blinker
    docutils
    feedgenerator
    jinja2
    lxml
    markupsafe
    pillow
    pygments
    python-dateutil
    pytz
    rich
    six
    unidecode
  ];

  checkInputs = [
    pytest-xdist
    pytestCheckHook
    pandoc
  ];

  postPatch = ''
    substituteInPlace pelican/tests/test_pelican.py \
      --replace "'git'" "'${git}/bin/git'"
  '';

  pytestFlagsArray = [
    # DeprecationWarning: 'jinja2.Markup' is deprecated and...
    "-W ignore::DeprecationWarning"
  ];

  disabledTests = [
    # AssertionError
    "test_basic_generation_works"
    "test_custom_generation_works"
    "test_custom_locale_generation_works"
  ];

  LC_ALL = "en_US.UTF-8";

  # We only want to patch shebangs in /bin, and not those
  # of the project scripts that are created by Pelican.
  # See https://github.com/NixOS/nixpkgs/issues/30116
  dontPatchShebangs = true;

  postFixup = ''
    patchShebangs $out/bin
  '';

  pythonImportsCheck = [ "pelican" ];

  meta = with lib; {
    description = "Static site generator that requires no database or server-side logic";
    homepage = "http://getpelican.com/";
    license = licenses.agpl3;
    maintainers = with maintainers; [ offline prikhi ];
  };
}
