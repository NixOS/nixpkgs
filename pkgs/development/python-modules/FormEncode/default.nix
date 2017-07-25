{ stdenv, buildPythonPackage, fetchPypi, dns, pycountry, nose }:

buildPythonPackage rec {
  pname = "FormEncode";
  version = "1.3.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xm77h2mds2prlaz0z4nzkx13g61rx5c2v3vpgjq9d5ij8bzb8md";
  };

  buildInputs = [ dns pycountry nose ];

  patchPhase = ''
    # dnspython3 has been superseded, see its PyPI page
    substituteInPlace setup.py --replace dnspython3 dnspython
  '';

  preCheck = ''
    # two tests require dns resolving
    sed -i 's/test_cyrillic_email/noop/' formencode/tests/test_email.py
    sed -i 's/test_unicode_ascii_subgroup/noop/' formencode/tests/test_email.py
  '';

  meta = with stdenv.lib; {
    description = "FormEncode validates and converts nested structures";
    homepage = "http://formencode.org";
    license = licenses.mit;
  };
}
