{
  lib,
  buildPythonPackage,
  fetchPypi,
  mock,
  pytest,
  pytest-mock,
  pytest-server-fixtures,
  pytest-localserver,
  termcolor,
  click,
  markdown2,
  six,
  jsonref,
  pyyaml,
  xmltodict,
  attrs,
}:

buildPythonPackage rec {
  pname = "ramlfications";
  version = "0.2.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wcQd5j74y7d0xFeWlwlhceZj95ixUmv5upnv/6Rl1ew=";
  };

  meta = with lib; {
    description = "Python RAML parser";
    mainProgram = "ramlfications";
    homepage = "https://ramlfications.readthedocs.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };

  doCheck = false;
  # [darwin]  AssertionError: Expected 'update_mime_types' to have been called once. Called 0 times.

  buildInputs = [
    mock
    pytest
    pytest-mock
    pytest-server-fixtures
    pytest-localserver
  ];

  propagatedBuildInputs = [
    termcolor
    click
    markdown2
    six
    jsonref
    pyyaml
    xmltodict
    attrs
  ];
}
