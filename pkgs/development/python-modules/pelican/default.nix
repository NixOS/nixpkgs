{ stdenv, buildPythonPackage, fetchFromGitHub, isPy26
, glibcLocales, pandoc, git
, mock, nose, markdown, lxml, typogrify
, jinja2, pygments, docutils, pytz, unidecode, six, dateutil, feedgenerator
, blinker, pillow, beautifulsoup4, markupsafe }:

buildPythonPackage rec {
  pname = "pelican";
  name = "${pname}-${version}";
  version = "3.7.1";
  disabled = isPy26;

  src = fetchFromGitHub {
    owner = "getpelican";
    repo = "pelican";
    rev = version;
    sha256 = "0nkxrb77k2bra7bqckg7f5k73wk98hcbz7rimxl8sw05b2bvd62g";
  };

  doCheck = true;

  checkPhase = ''
    python -Wd -m unittest discover
  '';

  buildInputs = [
    glibcLocales
    pandoc
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

  meta = with stdenv.lib; {
    description = "A tool to generate a static blog from reStructuredText or Markdown input files";
    homepage = "http://getpelican.com/";
    license = licenses.agpl3;
    maintainers = with maintainers; [ offline prikhi garbas ];
  };
}
