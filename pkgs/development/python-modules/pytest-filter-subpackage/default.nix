{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
  pytest-cov-stub,
  pytest-doctestplus,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytest-filter-subpackage";
  version = "0.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-P0aPGzZRgSiGm5Xeq2YbpF7WKThUMp/vFNpMjKx4r1Y=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    pytest-doctestplus
    pytest-cov-stub
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # missing some files
  disabledTests = [ "with_rst" ];

  meta = {
    description = "Meta-package containing dependencies for testing";
    homepage = "https://github.com/astropy/pytest-filter-subpackage";
    changelog = "https://github.com/astropy/pytest-filter-subpackage/blob/v${version}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
