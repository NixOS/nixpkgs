{ stdenv, buildPythonPackage, fetchPypi, pyramid_mako, nose, django, jinja2
, tornado, pyramid, Mako, six }:

buildPythonPackage rec {
  pname = "pyjade";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mycn5cc9cp4fb0i2vzgkkk6d0glnkbilggwb4i99i09vr0vg5cd";
  };

  buildInputs = [ pyramid_mako nose django jinja2 tornado pyramid Mako ];
  propagatedBuildInputs = [ six ];
  postPatch = ''
    sed -i 's/1.4.99/1.99/' setup.py
  '';
  checkPhase = ''
    nosetests pyjade
  '';
  # No tests distributed. https://github.com/syrusakbary/pyjade/issues/262
  doCheck = false;
  meta = with stdenv.lib; {
    description = "Jade syntax template adapter for Django, Jinja2, Mako and Tornado templates";
    homepage    = "https://github.com/syrusakbary/pyjade";
    license     = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}
