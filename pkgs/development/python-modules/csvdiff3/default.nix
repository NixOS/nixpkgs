{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, click
, colorama
, orderedmultidict
}:

buildPythonPackage rec {
  pname = "csvdiff3";
  version = "0.99.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sctweedie";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Nq4ZOxtO1hmDdPganbPPQ7asRNiPatz4VCRHJ2Jhpns=";
  };

  patches = [
    ./csvdiff3.patch
  ];

  propagatedBuildInputs = [
    click
    colorama
    orderedmultidict
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # For some reason it doesn't find the tests in that place
  preCheck = ''
    cp -r tests/testdata .
  '';

  # FIXME Can't get all them tests to run, help please!
  # doCheck = false;

  meta = with lib; {
    description = "3-way diff/merge tools for CSV files";
    homepage = "https://github.com/sctweedie/csvdiff3";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ turion ];
  };
}
