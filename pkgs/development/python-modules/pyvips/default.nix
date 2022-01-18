{ buildPythonPackage, fetchPypi, pytest-runner, pytestCheckHook, glib, vips, cffi
, pkg-config, pkgconfig, lib }:

buildPythonPackage rec {
  pname = "pyvips";
  version = "2.1.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "654c03014a15f846786807a2ece6f525a8fec883d1c857742c8e37da149a81ed";
  };

  nativeBuildInputs = [ pytest-runner pkgconfig pkg-config ];

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
