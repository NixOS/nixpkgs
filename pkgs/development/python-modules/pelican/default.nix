{ stdenv, buildPythonPackage, fetchFromGitHub
, glibcLocales, git
, mock, nose, markdown, lxml, typogrify
, jinja2, pygments, docutils, pytz, unidecode, six, dateutil, feedgenerator
, blinker, pillow, beautifulsoup4, markupsafe }:

buildPythonPackage rec {
  pname = "pelican";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "getpelican";
    repo = "pelican";
    rev = version;
    sha256 = "09fcwnnfln0cl5v0qpxzrllj27znrg6dbhaksxrl0192c3mbyjvl";
  };

  doCheck = true;

  checkPhase = ''
    python -Wd -m unittest discover
  '';

  buildInputs = [
    glibcLocales
    # Note: Pelican has to adapt to a changed CLI of pandoc before enabling this
    # again. Compare https://github.com/getpelican/pelican/pull/2252.
    # Version 4.0.1 is incompatible with our current pandoc version.
    # pandoc
    git
    mock
    nose
    markdown
    typogrify
  ];

  propagatedBuildInputs = [
    jinja2 pygments docutils pytz unidecode six dateutil feedgenerator
    blinker pillow beautifulsoup4 markupsafe lxml
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

  meta = with stdenv.lib; {
    description = "A tool to generate a static blog from reStructuredText or Markdown input files";
    homepage = http://getpelican.com/;
    license = licenses.agpl3;
    maintainers = with maintainers; [ offline prikhi garbas ];
  };
}
