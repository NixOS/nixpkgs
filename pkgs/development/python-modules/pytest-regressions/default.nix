{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, pythonOlder
, matplotlib
, numpy
, pandas
, pillow
, pytest
, pytest-datadir
, pytestCheckHook
, pyyaml
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-regressions";
  version = "2.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15a71f77cb266dd4ca94331abe4c339ad056b2b2175e47442711c98cf6d65716";
  };

  patches = [
    # Make pytest-regressions compatible with NumPy 1.20.
    # Should be part of the next release.
    (fetchpatch {
      url = "https://github.com/ESSS/pytest-regressions/commit/ffad2c7fd1d110f420f4e3ca3d39d90cae18a972.patch";
      sha256 = "sha256-bUna7MnMV6u9oEaZMsFnr4gE28rz/c0O2+Hyk291+l0=";
    })
  ];

  nativeBuildInputs = [ setuptools-scm ];
  buildInputs = [ pytest ];
  propagatedBuildInputs = [ numpy pandas pillow pytest-datadir pyyaml ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  checkInputs = [ pytestCheckHook matplotlib ];
  pythonImportsCheck = [ "pytest_regressions" "pytest_regressions.plugin" ];

  meta = with lib; {
    description = "Pytest fixtures to write regression tests";
    longDescription = ''
      pytest-regressions makes it simple to test general data, images,
      files, and numeric tables by saving expected data in a data
      directory (courtesy of pytest-datadir) that can be used to verify
      that future runs produce the same data.
    '';
    homepage = "https://github.com/ESSS/pytest-regressions";
    license = licenses.mit;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
