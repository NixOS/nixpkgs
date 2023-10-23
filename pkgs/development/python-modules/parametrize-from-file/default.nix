{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, pytestCheckHook
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
  version = "0.18.0";
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "parametrize_from_file";
    hash = "sha256-mYE8J7XWlvCS2H3kt0bB8dyPHFDqmW8NiH9UCrNccAU=";
  };

  # patch out coveralls since it doesn't provide us value
  preBuild = ''
    sed -i '/coveralls/d' ./pyproject.toml

    substituteInPlace pyproject.toml \
      --replace "more_itertools~=8.10" "more_itertools"
  '';

  nativeBuildInputs = [
    flit-core
  ];

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
