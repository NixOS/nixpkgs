{ lib
, buildPythonApplication
, fetchFromGitHub
, fetchpatch
, cpyparsing
, ipykernel
, mypy
, pexpect
, pygments
, pytestCheckHook
, prompt-toolkit
, tkinter
, watchdog
}:

buildPythonApplication rec {
  pname = "coconut";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "evhub";
    repo = "coconut";
    rev = "v${version}";
    sha256 = "1gc0fwqwzn1j6mcg1f6fw832w66pbaaq9mmi0r4kw3xn5f877icz";
  };

  propagatedBuildInputs = [ cpyparsing ipykernel mypy pygments prompt-toolkit watchdog ];

  postPatch = ''
    substituteInPlace coconut/kernel_installer.py \
      --replace "fixpath(os.path.join(sys.exec_prefix, icoconut_custom_kernel_install_loc))" \
                "fixpath(icoconut_custom_kernel_install_loc)"
  '';

  checkInputs = [ pexpect pytestCheckHook tkinter ];

  # Currently most tests do not work on Hydra due to external fetches.
  pytestFlagsArray = [
    "tests/constants_test.py"
    "tests/main_test.py::TestShell::test_compile_to_file"
    "tests/main_test.py::TestShell::test_convenience"
  ];

  pythonImportsCheck = [ "coconut" ];

  meta = with lib; {
    homepage = "http://coconut-lang.org/";
    description = "Simple, elegant, Pythonic functional programming";
    license = licenses.asl20;
    maintainers = with maintainers; [ fabianhjr ];
  };
}
