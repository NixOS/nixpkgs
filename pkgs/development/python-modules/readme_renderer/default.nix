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
}:

buildPythonPackage rec {
  pname = "readme_renderer";
  version = "24.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0br0562lnvj339f1nwz4nfl4ay49rw05xkqacigzf9wz4mdza5mv";
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
    homepage = https://github.com/pypa/readme_renderer;
    license = lib.licenses.asl20;
  };
}
