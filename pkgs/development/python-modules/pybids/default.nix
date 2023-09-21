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
  version = "0.15.6";
  pname = "pybids";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OjWW08tyVDHkF0X3Pa+10HYD/7Gysp5DkEt9LaVxsdM=";
  };

  patches = [
    # remove after next release
    (fetchpatch {
      name = "fix-pybids-sqlalchemy-dep";
      url = "https://github.com/bids-standard/pybids/commit/5f008dfc282394ef94a68d47dba37ceead9eac9a.patch";
      hash = "sha256-gx6w35XqDBZ8cTGHeY/mz2xNQqza9E5z8bRJR7mbPcg=";
      excludes = [ "pyproject.toml" ];  # not in PyPI dist
    })
  ];

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
  # looks for missing data:
  disabledTests = [ "test_config_filename" ];

  meta = with lib; {
    description = "Python tools for querying and manipulating BIDS datasets";
    homepage = "https://github.com/bids-standard/pybids";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
