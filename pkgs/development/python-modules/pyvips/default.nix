{ buildPythonPackage, fetchPypi, pytestrunner, pytestCheckHook, glib, vips, cffi
, pkg-config, pkgconfig, lib }:

buildPythonPackage rec {
  pname = "pyvips";
  version = "2.1.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pg0dxhxgi2m7bb5bi5wpx9hgnbi8ws1bz6w2dldbhi52pizghl4";
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
