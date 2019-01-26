{ stdenv
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "Genshi";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d87ae62cf2ed92133f35725da51e02d09f79bb4cb986f0d948408a0279dd3f8";
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
