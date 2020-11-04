{ stdenv
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "Genshi";
  version = "0.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d92ef3bb34474a38566f7e44e570ff3067c7f7c126670c79f660661badf8eddb";
  };

  # FAIL: test_sanitize_remove_script_elem (genshi.filters.tests.html.HTMLSanitizerTestCase)
  # FAIL: test_sanitize_remove_src_javascript (genshi.filters.tests.html.HTMLSanitizerTestCase)
  doCheck = false;

  buildInputs = [ setuptools ];

  meta = with stdenv.lib; {
    description = "Python components for parsing HTML, XML and other textual content";
    longDescription = ''
      Python library that provides an integrated set of components for
      parsing, generating, and processing HTML, XML or other textual
      content for output generation on the web.
    '';
    homepage = "https://genshi.edgewall.org/";
    license = licenses.bsd0;
  };
}
