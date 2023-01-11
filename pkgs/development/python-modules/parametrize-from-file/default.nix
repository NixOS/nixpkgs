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

  src = fetchPypi {
    inherit version;
    pname = "parametrize_from_file";
    sha256 = "1c91j869n2vplvhawxc1sv8km8l53bhlxhhms43fyjsqvy351v5j";
  };

  format = "flit";
  pythonImportsCheck = [ "parametrize_from_file" ];

  # patch out coveralls since it doesn't provide us value
  preBuild = ''
    sed -i '/coveralls/d' ./pyproject.toml
  '';

  checkInputs = [
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

  meta = with lib; {
    description = "Read unit test parameters from config files";
    homepage = "https://github.com/kalekundert/parametrize_from_file";
    changelog = "https://github.com/kalekundert/parametrize_from_file/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
