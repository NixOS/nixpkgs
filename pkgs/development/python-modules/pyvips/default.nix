{ buildPythonPackage, fetchPypi, pytestrunner, pytestCheckHook, glib, vips, cffi
, pkg-config, pkgconfig, lib }:

buildPythonPackage rec {
  pname = "pyvips";
  version = "2.1.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "244e79c625be65237677c79424d4476de6c406805910015d4adbd0186c64a6a2";
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
