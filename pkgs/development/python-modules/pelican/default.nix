{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pythonRelaxDepsHook

# build-system
, pdm-backend

# native dependencies
, glibcLocales
, git
, pandoc
, typogrify

# dependencies
, backports-zoneinfo
, blinker
, docutils
, feedgenerator
, jinja2
, markdown
, ordered-set
, pygments
, python-dateutil
, rich
, tzdata
, unidecode
, watchfiles

# tests
, mock
, pytestCheckHook
, pytest-xdist
}:

buildPythonPackage rec {
  pname = "pelican";
  version = "4.9.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "getpelican";
    repo = "pelican";
    rev = "refs/tags/${version}";
    hash = "sha256-nz2OnxJ4mGgnafz4Xp8K/BTyVgXNpNYqteNL1owP8Hk=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    postFetch = ''
      rm -r $out/pelican/tests/output/custom_locale/posts
    '';
  };

  postPatch = ''
    substituteInPlace pelican/tests/test_pelican.py \
      --replace "'git'" "'${git}/bin/git'"
  '';

  nativeBuildInputs = [
    pdm-backend
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "unidecode"
  ];

  buildInputs = [
    glibcLocales
    pandoc
    git
    markdown
    typogrify
  ];

  propagatedBuildInputs = [
    blinker
    docutils
    feedgenerator
    jinja2
    ordered-set
    pygments
    python-dateutil
    rich
    tzdata
    unidecode
    watchfiles
  ] ++ lib.optionals (pythonOlder "3.9") [
    backports-zoneinfo
  ];

  nativeCheckInputs = [
    mock
    pytest-xdist
    pytestCheckHook
    pandoc
  ];

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

  env.LC_ALL = "en_US.UTF-8";

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
    homepage = "https://getpelican.com/";
    license = licenses.agpl3;
    maintainers = with maintainers; [ offline prikhi ];
  };
}
