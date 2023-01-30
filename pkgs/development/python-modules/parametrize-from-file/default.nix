{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, coveralls
, numpy
, contextlib2
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
    sha256 = "1c91j869n2vplvhawxc1sv8km8l53bhlxhhms43fyjsqvy351v5j";
  };

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
    contextlib2
    decopatch
    more-itertools
    nestedtext
    pyyaml
    tidyexc
    toml
  ];

  pythonImportsCheck = [ "parametrize_from_file" ];

  meta = with lib; {
    description = "Read unit test parameters from config files";
    homepage = "https://github.com/kalekundert/parametrize_from_file";
    changelog = "https://github.com/kalekundert/parametrize_from_file/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
