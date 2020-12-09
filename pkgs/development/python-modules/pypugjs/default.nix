{ stdenv, buildPythonPackage, fetchFromGitHub, fetchpatch, six, chardet, nose
, django, jinja2, tornado, pyramid, pyramid_mako, Mako }:

buildPythonPackage rec {
  pname = "pypugjs";
  version = "5.9.7";

  # PyPI source tarball is missing files
  # https://github.com/kakulukia/pypugjs/issues/68
  src = fetchFromGitHub {
    owner = "kakulukia";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wvl0n5c3xpani5yn1740f9yd72pjcqg7zy7sj4553m0mlwj9pvc";
  };

  propagatedBuildInputs = [ six chardet ];
  checkInputs = [ nose django jinja2 tornado pyramid pyramid_mako Mako ];

  checkPhase = ''
    nosetests pypugjs
  '';

  meta = with stdenv.lib; {
    description = "PugJS syntax template adapter for Django, Jinja2, Mako and Tornado templates";
    homepage = "https://github.com/kakulukia/pypugjs";
    license = licenses.mit;
    maintainers = with maintainers; [ lopsided98 ];
  };
}
