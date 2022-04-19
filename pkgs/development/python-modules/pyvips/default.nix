{ buildPythonPackage, fetchPypi, pytest-runner, pytestCheckHook, glib, vips, cffi
, pkg-config, pkgconfig, lib }:

buildPythonPackage rec {
  pname = "pyvips";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-64ywtXxTOkBLKwDqTayVtwgeSIgPmNwhRuwSFmMMB1M=";
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
