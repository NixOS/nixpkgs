{ stdenv, buildPythonPackage, fetchFromGitHub
, glibcLocales, git
, mock, nose, markdown, lxml, typogrify
, jinja2, pygments, docutils, pytz, unidecode, six, dateutil, feedgenerator
, blinker, pillow, beautifulsoup4, markupsafe }:

buildPythonPackage rec {
  pname = "pelican";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "getpelican";
    repo = "pelican";
    rev = version;
    sha256 = "08lwbkgqdf6qx9vg17qj70k7nz2j34ymlnrc4cbz7xj98cw4ams1";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    extraPostFetch = ''
      rm -r $out/pelican/tests/output/custom_locale/posts
    '';
  };

  doCheck = true;

  # Exclude custom locale test, which files were removed above to fix the source checksum
  checkPhase = ''
    nosetests -sv --exclude=test_custom_locale_generation_works pelican
  '';

  buildInputs = [
    glibcLocales
    # Note: Pelican has to adapt to a changed CLI of pandoc before enabling this
    # again. Compare https://github.com/getpelican/pelican/pull/2252.
    # Version 4.1.1 is incompatible with our current pandoc version.
    # pandoc
    git
    mock
    markdown
    typogrify
  ];

  propagatedBuildInputs = [
    jinja2 pygments docutils pytz unidecode six dateutil feedgenerator
    blinker pillow beautifulsoup4 markupsafe lxml
  ];

  checkInputs = [
    nose
  ];

  postPatch= ''
    substituteInPlace pelican/tests/test_pelican.py \
      --replace "'git'" "'${git}/bin/git'"

    # Markdown-3.1 changed footnote separator to colon
    # https://github.com/getpelican/pelican/issues/2493#issuecomment-491723744
    sed -i '/test_article_with_footnote/i\
        @unittest.skip("")' pelican/tests/test_readers.py
  '';

  LC_ALL="en_US.UTF-8";


  # We only want to patch shebangs in /bin, and not those
  # of the project scripts that are created by Pelican.
  # See https://github.com/NixOS/nixpkgs/issues/30116
  dontPatchShebangs = true;

  postFixup = ''
    patchShebangs $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A tool to generate a static blog from reStructuredText or Markdown input files";
    homepage = http://getpelican.com/;
    license = licenses.agpl3;
    maintainers = with maintainers; [ offline prikhi ];
  };
}
