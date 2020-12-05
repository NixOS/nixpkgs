{ stdenv, buildPythonPackage, fetchFromGitHub, fetchpatch, six, chardet, nose
, django, jinja2, tornado, pyramid, pyramid_mako, Mako }:

buildPythonPackage rec {
  pname = "pypugjs";
  version = "5.9.6";

  # No source tarball on PyPI
  # https://github.com/kakulukia/pypugjs/issues/68
  src = fetchFromGitHub {
    owner = "kakulukia";
    repo = pname;
    rev = "v${version}";
    sha256 = "14hsl4jfzy5hf5qiwpjdy6vzzj9mvd2rvkcvjgciyz06vfccqd7y";
  };

  patches = [
    # Allow newer pyramid versions
    # https://github.com/kakulukia/pypugjs/pull/69
    (fetchpatch {
      url = "https://github.com/kakulukia/pypugjs/commit/2a77a59bee8526f7e3eb9d71c8241470dfff11f5.patch";
      sha256 = "0d2bjh0f8hmbvmzi8ilj1xbpgszhhkapiql8yi0by2lrd525qspn";
    })
  ];

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
