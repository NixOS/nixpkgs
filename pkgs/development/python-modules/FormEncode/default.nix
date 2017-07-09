{ stdenv, buildPythonPackage, fetchPypi, dns, pycountry, nose }:

buildPythonPackage rec {
  pname = "FormEncode";
  version = "1.3.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0y5gywq0l79l85ylr55p4xy0h921zgmfw6zmrvlh83aa4j074xg6";
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
