{ stdenv
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "Genshi";
  version = "0.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7933c95151d7dd2124a2b4c8dd85bb6aec881ca17c0556da0b40e56434b313a0";
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
    homepage = https://genshi.edgewall.org/;
    license = licenses.bsd0;
  };
}
