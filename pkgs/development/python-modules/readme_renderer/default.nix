{ lib
, buildPythonPackage
, fetchPypi
, pytest
, bleach
, docutils
, pygments
, six
}:

buildPythonPackage rec {
  pname = "readme_renderer";
  version = "17.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9deab442963a63a71ab494bf581b1c844473995a2357f4b3228a1df1c8cba8da";
  };

  checkInputs = [ pytest ];

  propagatedBuildInputs = [
    bleach docutils pygments six
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