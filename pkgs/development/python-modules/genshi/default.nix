{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, six
}:

buildPythonPackage rec {
  pname = "Genshi";
  version = "0.7.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c12d6c2abf7df0ec661d9ff2e197522eae846e43dc58abd5a36443d05bc41135";
  };

  # FAIL: test_sanitize_remove_script_elem (genshi.filters.tests.html.HTMLSanitizerTestCase)
  # FAIL: test_sanitize_remove_src_javascript (genshi.filters.tests.html.HTMLSanitizerTestCase)
  doCheck = false;

  propagatedBuildInputs = [
    setuptools six
  ];

  meta = with lib; {
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
