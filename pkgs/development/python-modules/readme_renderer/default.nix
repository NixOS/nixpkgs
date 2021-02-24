{ lib
, buildPythonPackage
, fetchPypi
, pytest
, mock
, cmarkgfm
, bleach
, docutils
, future
, pygments
, six
, pythonOlder
}:

buildPythonPackage rec {
  pname = "readme_renderer";
  version = "29.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-kv1awr+Gd/MQ8zA6pLzludX58glKuYwp8TeR17gFo9s=";
  };

  checkInputs = [ pytest mock ];

  propagatedBuildInputs = [
    bleach cmarkgfm docutils future pygments six
  ];

  checkPhase = ''
    # disable one failing test case
    # fixtures test is failing for incorrect class name
    py.test -k "not test_invalid_link and not fixtures"
  '';

  meta = {
    description = "readme_renderer is a library for rendering readme descriptions for Warehouse";
    homepage = "https://github.com/pypa/readme_renderer";
    license = lib.licenses.asl20;
  };
}
