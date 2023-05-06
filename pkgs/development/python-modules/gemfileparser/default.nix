{ lib
, fetchPypi
, buildPythonPackage
, pytestCheckHook
}:
buildPythonPackage rec {
  pname = "gemfileparser";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "839592e49ea3fd985cec003ef58f8e77009a69ed7644a0c0acc94cf6dd9b8d6e";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "gemfileparser"
  ];

  meta = with lib; {
    description = "A library to parse Ruby Gemfile, .gemspec and Cocoapod .podspec file using Python";
    homepage = "https://github.com/gemfileparser/gemfileparser";
    license = with licenses; [ gpl3Plus /* or */ mit ];
    maintainers = [ ];
  };
}
