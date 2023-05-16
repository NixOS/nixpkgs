{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

# This package provides a binary "apython" which sometimes invokes
# [sys.executable, '-m', 'aioconsole'] as a subprocess. If apython is
# run directly out of this derivation, it won't work, because
# sys.executable will point to a Python binary that is not wrapped to
# be able to find aioconsole.
# However, apython will work fine when using python##.withPackages,
# because with python##.withPackages the sys.executable is already
# wrapped to be able to find aioconsole and any other packages.
buildPythonPackage rec {
  pname = "aioconsole";
<<<<<<< HEAD
  version = "0.6.2";
=======
  version = "0.6.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "vxgmichel";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-axUJLh7yg2A+HB0fxBueuNT/rohHVq6svQUZvR2LKzo=";
=======
    hash = "sha256-XR79o65jZFR9jr9ubw7wdxCWNH8ANMrBDTVpLnetsuU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov aioconsole --count 2" ""
  '';

  __darwinAllowLocalNetworking = true;

  disabledTests = [
    "test_interact_syntax_error"
    # Output and the sandbox don't work well together
    "test_interact_multiple_indented_lines"
  ];

  pythonImportsCheck = [
    "aioconsole"
  ];

  meta = with lib; {
    description = "Asynchronous console and interfaces for asyncio";
    homepage = "https://github.com/vxgmichel/aioconsole";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ catern ];
  };
}
