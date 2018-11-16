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
  version = "22.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lj3k3x7wm0w5xdy82jwl0fmchqmlkdh24g41n3lka7ybxqahz13";
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
