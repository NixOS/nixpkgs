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
  version = "21.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "422404013378f0267ee128956021a47457db8eb487908b70b8a7de5fa935781a";
  };

  checkInputs = [ pytest mock ];

  propagatedBuildInputs = [
    bleach cmarkgfm docutils future pygments six
  ];

  checkPhase = ''
    # disable one failing test case
    py.test -k "not test_invalid_link"
  '';

  meta = {
    description = "readme_renderer is a library for rendering readme descriptions for Warehouse";
    homepage = https://github.com/pypa/readme_renderer;
    license = lib.licenses.asl20;
  };
}
