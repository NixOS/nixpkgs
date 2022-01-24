{ lib
, buildPythonPackage
, cssselect
, fetchPypi
, functools32
, isPy27
, lxml
, pytestCheckHook
, six
, w3lib
}:

buildPythonPackage rec {
  pname = "parsel";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yawf9r3r863lwxj0n89i7h3n8xjbsl5b7n6xg76r68scl5yzvvh";
  };

  propagatedBuildInputs = [
    cssselect
    lxml
    six
    w3lib
  ] ++ lib.optionals isPy27 [
    functools32
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'," ""
  '';

  disabledTests = [
    # Test are out-dated and are failing (AssertionError: Lists differ: ...)
    # https://github.com/scrapy/parsel/pull/174
    "test_differences_parsing_xml_vs_html"
    "test_nested_selectors"
    "test_re"
    "test_replacement_null_char_from_body"
    "test_select_on_text_nodes"
    "test_selector_get_alias"
    "test_selector_getall_alias"
    "test_selector_over_text"
    "test_selectorlist_get_alias"
    "test_selectorlist_getall_alias"
    "test_slicing"
    "test_text_pseudo_element"
  ];

  pythonImportsCheck = [ "parsel" ];

  meta = with lib; {
    homepage = "https://github.com/scrapy/parsel";
    description = "Python library to extract data from HTML and XML using XPath and CSS selectors";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
