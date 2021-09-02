{ lib, fetchFromGitHub, buildPythonPackage
, pythonAtLeast
, isPy27
, nose
, cached-property
, configargparse
, jinja2
, pyparsing
, six }:

buildPythonPackage rec {
  pname = "gixy";
  version = "0.1.20";

  # package is only compatible with python 2.7 and 3.5+
  disabled = !(pythonAtLeast "3.5" || isPy27);

  # fetching from GitHub because the PyPi source is missing the tests
  src = fetchFromGitHub {
    owner = "yandex";
    repo = "gixy";
    rev = "v${version}";
    sha256 = "14arz3fjidb8z37m08xcpih1391varj8s0v3gri79z3qb4zq5k6b";
  };

  postPatch = ''
    sed -ie '/argparse/d' setup.py
  '';

  checkInputs = [
    nose
  ];

  propagatedBuildInputs = [
    cached-property
    configargparse
    jinja2
    pyparsing
    six
  ];

  meta = with lib; {
    description = "Nginx configuration static analyzer";
    longDescription = ''
      Gixy is a tool to analyze Nginx configuration.
      The main goal of Gixy is to prevent security misconfiguration and automate flaw detection.
    '';
    homepage = "https://github.com/yandex/gixy";
    license = licenses.mpl20;
    maintainers = [ maintainers.willibutz ];
    platforms = platforms.unix;
  };
}
