{ lib
, buildPythonApplication
, fetchFromGitHub
, fetchpatch
, cpyparsing
, ipykernel
, mypy
, pygments
, pytestCheckHook
, prompt_toolkit
, tkinter
, watchdog
}:

buildPythonApplication rec {
  pname = "coconut";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "evhub";
    repo = "coconut";
    rev = "v${version}";
    sha256 = "1pz13vza3yy95dbylnq89fzc3mwgcqr7ds096wy25k6vxd9dp9c3";
  };

  propagatedBuildInputs = [ cpyparsing pygments prompt_toolkit ipykernel mypy watchdog ];

  patches = [
    (fetchpatch {
      name = "fix-setuptools-version-check.patch";
      url = "https://github.com/LibreCybernetics/coconut/commit/2916a087da1e063cc4438b68d4077347fd1ea4a2.patch";
      sha256 = "136jbd2rvnifw30y73vv667002nf7sbkm5qyihshj4db7ngysr6q";
    })
  ];

  checkInputs = [
    pytestCheckHook
    tkinter
  ];

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
