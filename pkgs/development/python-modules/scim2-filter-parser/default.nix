{ stdenv, lib, fetchFromGitHub, buildPythonPackage, unittestCheckHook
, pytest-runner, django
, sly }:

buildPythonPackage rec {
  pname = "scim2-filter-parser";
  version = "0.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "15five";
    repo = pname;
    # gets rarely updated, we can then just replace the hash
    rev = "refs/tags/${version}";
    hash = "sha256-ZemR5tn+T9WWgNB1FYrPJO6zh8g9zjobFZemi+MHkEE=";
  };

  propagatedBuildInputs = [
    sly
  ];

  pythonImportsCheck = [
    "scim2_filter_parser"
  ];

  checkInputs = [
    django
    pytest-runner
    unittestCheckHook
  ];

  meta = with lib; {
    description = "A customizable parser/transpiler for SCIM2.0 filters";
    homepage    = "https://github.com/15five/scim2-filter-parser";
    license     = licenses.mit;
    maintainers = with maintainers; [ s1341 ];
  };
}
