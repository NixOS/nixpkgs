{ lib, buildPythonPackage, fetchFromGitHub, isPy27
, glibcLocales, git
, mock, nose, markdown, lxml, typogrify
, jinja2, pygments, docutils, pytz, unidecode, six, python-dateutil, feedgenerator
, blinker, pillow, beautifulsoup4, markupsafe, pandoc }:

buildPythonPackage rec {
  pname = "pelican";
  version = "4.5.4";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "getpelican";
    repo = "pelican";
    rev = version;
    sha256 = "08l8kk3c7ca1znxmgdmfgzn28dzjcziwflzq80fn9zigqj0y7fi8";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    extraPostFetch = ''
      rm -r $out/pelican/tests/output/custom_locale/posts
    '';
  };

  doCheck = true;

  # Exclude custom locale test, which files were removed above to fix the source checksum
  checkPhase = ''
    nosetests -s \
      --exclude=test_basic_generation_works \
      --exclude=test_custom_generation_works \
      --exclude=test_custom_locale_generation_works \
      --exclude=test_log_filter \
      pelican
  '';

  buildInputs = [
    glibcLocales
    pandoc
    git
    mock
    markdown
    typogrify
  ];

  propagatedBuildInputs = [
    jinja2 pygments docutils pytz unidecode six python-dateutil feedgenerator
    blinker pillow beautifulsoup4 markupsafe lxml
  ];

  checkInputs = [
    nose
    pandoc
  ];

  postPatch= ''
    substituteInPlace pelican/tests/test_pelican.py \
      --replace "'git'" "'${git}/bin/git'"
  '';

  LC_ALL="en_US.UTF-8";

  # We only want to patch shebangs in /bin, and not those
  # of the project scripts that are created by Pelican.
  # See https://github.com/NixOS/nixpkgs/issues/30116
  dontPatchShebangs = true;

  postFixup = ''
    patchShebangs $out/bin
  '';

  meta = with lib; {
    description = "A tool to generate a static blog from reStructuredText or Markdown input files";
    homepage = "http://getpelican.com/";
    license = licenses.agpl3;
    maintainers = with maintainers; [ offline prikhi ];
  };
}
