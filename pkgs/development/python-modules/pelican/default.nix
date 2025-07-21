{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  pdm-backend,

  # native dependencies
  glibcLocales,
  git,
  pandoc,
  typogrify,

  # dependencies
  blinker,
  docutils,
  feedgenerator,
  jinja2,
  markdown,
  ordered-set,
  pygments,
  python-dateutil,
  rich,
  tzdata,
  unidecode,
  watchfiles,

  # tests
  beautifulsoup4,
  lxml,
  mock,
  pytestCheckHook,
  pytest-xdist,
}:

buildPythonPackage rec {
  pname = "pelican";
  version = "4.11.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "getpelican";
    repo = "pelican";
    tag = version;
    hash = "sha256-SrzHAqDX+DCeaWMmlG8tgA1RKLDnICkvDIE/kUQZN+s=";
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

  build-system = [ pdm-backend ];

  pythonRelaxDeps = [ "pygments" ];

  buildInputs = [
    glibcLocales
    pandoc
    git
    markdown
    typogrify
  ];

  dependencies = [
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
  ];

  optional-dependencies = {
    markdown = [ markdown ];
  };

  nativeCheckInputs = [
    beautifulsoup4
    lxml
    mock
    pandoc
    pytest-xdist
    pytestCheckHook
  ];

  pytestFlags = [
    # DeprecationWarning: 'jinja2.Markup' is deprecated and...
    "-Wignore::DeprecationWarning"
  ];

  disabledTests = [
    # AssertionError
    "test_basic_generation_works"
    "test_custom_generation_works"
    "test_custom_locale_generation_works"
    "test_deprecated_attribute"
    # AttributeError
    "test_wp_custpost_true_dirpage_false"
    "test_can_toggle_raw_html_code_parsing"
    "test_dirpage_directive_for_page_kind"
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
    changelog = "https://github.com/getpelican/pelican/blob/${src.tag}/docs/changelog.rst";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      offline
      prikhi
    ];
  };
}
