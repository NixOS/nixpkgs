{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fastjsonschema";
  version = "2.15.2";
  format = "setuptools";

  disabled = pythonOlder "3.3";

  src = fetchFromGitHub {
    owner = "horejsek";
    repo = "python-fastjsonschema";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-zrdQVFfLZxZRr9qvss4CI3LJK97xl+bY+AcPzcweYeU=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  dontUseSetuptoolsCheck = true;

  patches = [
    # Can be removed with the next release, https://github.com/horejsek/python-fastjsonschema/pull/134
    (fetchpatch {
      name = "fix-exception-name.patch";
      url = "https://github.com/horejsek/python-fastjsonschema/commit/f639dcba0299926d688e1d8d08a6a91bfe70ce8b.patch";
      sha256 = "sha256-yPV5ZNeyAobLrYf5QHanPsEomBPJ/7ZN2148R8NO4/U=";
    })
  ];


  disabledTests = [
    "benchmark"
    # these tests require network access
    "remote ref"
    "definitions"
  ];

  pythonImportsCheck = [
    "fastjsonschema"
  ];

  meta = with lib; {
    description = "JSON schema validator for Python";
    homepage = "https://horejsek.github.io/python-fastjsonschema/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
