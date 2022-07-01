{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, six
}:

buildPythonPackage rec {
  pname = "Genshi";
  version = "0.7.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wQBSCGLNaQhdEO4ah+kSief1n2s9m9Yiv1iygE5rmqs=";
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
