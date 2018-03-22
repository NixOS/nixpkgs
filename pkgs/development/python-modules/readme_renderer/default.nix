{ lib
, buildPythonPackage
, fetchPypi
, pytest
, CommonMark
, bleach
, docutils
, pygments
, six
}:

buildPythonPackage rec {
  pname = "readme_renderer";
  version = "17.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "82d68175feec897af2a38fe8590778f14c3be5324cc62e3ce5752a9b1e4b60ab";
  };

  checkInputs = [ pytest ];

  propagatedBuildInputs = [
    CommonMark bleach docutils pygments six
  ];

  checkPhase = ''
    py.test
  '';

  meta = {
    description = "readme_renderer is a library for rendering readme descriptions for Warehouse";
    homepage = https://github.com/pypa/readme_renderer;
    license = lib.licenses.asl20;
  };
}
