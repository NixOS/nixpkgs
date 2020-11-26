{ buildPythonPackage, fetchPypi, pytestrunner, pytestCheckHook, glib, vips, cffi
, pkg-config, pkgconfig, lib }:

buildPythonPackage rec {
  pname = "pyvips";
  version = "2.1.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4f1f6fa19893048bf6b950eb7eb2d4cdfeb8b940a9defaca5d4f79e5acd5085f";
  };

  nativeBuildInputs = [ pytestrunner pkgconfig pkg-config ];

  buildInputs = [ glib vips ];

  propagatedBuildInputs = [ cffi ];

  # tests are not included in pypi tarball
  doCheck = false;
  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyvips" ];

  meta = with lib; {
    description = "A python wrapper for libvips";
    homepage = "https://github.com/libvips/pyvips";
    license = licenses.mit;
    maintainers = with maintainers; [ ccellado ];
  };
}
