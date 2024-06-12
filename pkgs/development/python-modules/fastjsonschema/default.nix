{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "fastjsonschema";
  version = "2.19.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "horejsek";
    repo = "python-fastjsonschema";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-UxcxVB4ldnGAYJKWEccivon1CwZD588mNiVJOJPNeN8=";
  };

  patches = [
    (fetchpatch2 {
      name = "fastjsonschema-pytest8-compat.patch";
      url = "https://github.com/horejsek/python-fastjsonschema/commit/efc04daf4124a598182dfcfd497615cd1e633d18.patch";
      hash = "sha256-G1/PIpdN+KFfRP9pUFf/ANXLq3mzrocEHyBNWQMVOZM=";
    })
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  dontUseSetuptoolsCheck = true;

  disabledTests =
    [
      "benchmark"
      # these tests require network access
      "remote ref"
      "definitions"
    ]
    ++ lib.optionals stdenv.isDarwin [
      "test_compile_to_code_custom_format" # cannot import temporary module created during test
    ];

  pythonImportsCheck = [ "fastjsonschema" ];

  meta = with lib; {
    description = "JSON schema validator for Python";
    homepage = "https://horejsek.github.io/python-fastjsonschema/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
