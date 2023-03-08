{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pytestCheckHook
, coveralls
, numpy
, decopatch
, more-itertools
, nestedtext
, pyyaml
, tidyexc
, toml
}:

buildPythonPackage rec {
  pname = "parametrize-from-file";
  version = "0.17.0";
  format = "flit";

  src = fetchPypi {
    inherit version;
    pname = "parametrize_from_file";
    hash = "sha256-suxQht9YS+8G0RXCTuEahaI60daBda7gpncLmwySIbE=";
  };

  patches = [
    (fetchpatch {
      name = "replace contextlib2-with-contextlib.patch";
      url = "https://github.com/kalekundert/parametrize_from_file/commit/edee706770a713130da7c4b38b0a07de1bd79c1b.patch";
      hash = "sha256-VkPKGkYYTB5XCavtEEnFJ+EdNUUhITz/euwlYAPC/tQ=";
    })
  ];

  # patch out coveralls since it doesn't provide us value
  preBuild = ''
    sed -i '/coveralls/d' ./pyproject.toml

    substituteInPlace pyproject.toml \
      --replace "more_itertools~=8.10" "more_itertools"
  '';

  nativeCheckInputs = [
    numpy
    pytestCheckHook
  ];

  propagatedBuildInputs = [
    decopatch
    more-itertools
    nestedtext
    pyyaml
    tidyexc
    toml
  ];

  pythonImportsCheck = [
    "parametrize_from_file"
  ];

  disabledTests = [
    # https://github.com/kalekundert/parametrize_from_file/issues/19
    "test_load_suite_params_err"
  ];

  meta = with lib; {
    description = "Read unit test parameters from config files";
    homepage = "https://github.com/kalekundert/parametrize_from_file";
    changelog = "https://github.com/kalekundert/parametrize_from_file/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
