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
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "vxgmichel";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-/20FR7yc2aMA9cL3l7XAL/kak3cBBTniAICLC/TOI+U=";
  };

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov aioconsole --count 2" ""
  '';

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
