{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder, black, isort
, pytestCheckHook, pyyaml, typing-extensions, typing-inspect }:

buildPythonPackage rec {
  pname = "libcst";
  version = "0.3.13";

  # Some files for tests missing from PyPi
  # https://github.com/Instagram/LibCST/issues/331
  src = fetchFromGitHub {
    owner = "instagram";
    repo = pname;
    rev = "v${version}";
    sha256 = "0pbddjrsqj641mr6zijk2phfn15dampbx268zcws4bhhhnrxlj65";
  };

  disabled = pythonOlder "3.6";

  propagatedBuildInputs = [ pyyaml typing-inspect ];

  checkInputs = [ black isort pytestCheckHook ];

  # https://github.com/Instagram/LibCST/issues/346
  # https://github.com/Instagram/LibCST/issues/347
  preCheck = ''
    python -m libcst.codegen.generate visitors
    python -m libcst.codegen.generate return_types
    rm libcst/tests/test_fuzz.py
    rm libcst/tests/test_pyre_integration.py
    rm libcst/metadata/tests/test_full_repo_manager.py
    rm libcst/metadata/tests/test_type_inference_provider.py
  '';

  pythonImportsCheck = [ "libcst" ];

  meta = with lib; {
    description =
      "A Concrete Syntax Tree (CST) parser and serializer library for Python.";
    homepage = "https://github.com/Instagram/libcst";
    license = with licenses; [ mit asl20 psfl ];
    maintainers = with maintainers; [ maintainers.ruuda ];
  };
}
