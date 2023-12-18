{ buildPythonPackage
, lib
, fetchPypi
, fetchpatch
, formulaic
, click
, num2words
, numpy
, scipy
, pandas
, nibabel
, patsy
, bids-validator
, sqlalchemy
, pytestCheckHook
, versioneer
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  version = "0.16.3";
  format = "setuptools";
  pname = "pybids";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EOJ5NQyNFMpgLA1EaaXkv3/zk+hkPIMaVGrnNba4LMM=";
  };

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  pythonRelaxDeps = [ "sqlalchemy" ];

  propagatedBuildInputs = [
    click
    formulaic
    num2words
    numpy
    scipy
    pandas
    nibabel
    patsy
    bids-validator
    sqlalchemy
    versioneer
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "bids" ];
  disabledTests = [
    # looks for missing data:
    "test_config_filename"
    # regression associated with formulaic >= 0.6.0
    # (see https://github.com/bids-standard/pybids/issues/1000)
    "test_split"
  ];

  meta = with lib; {
    description = "Python tools for querying and manipulating BIDS datasets";
    homepage = "https://github.com/bids-standard/pybids";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
