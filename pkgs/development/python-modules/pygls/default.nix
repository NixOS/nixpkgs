{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, lsprotocol
, typeguard
, poetry-core
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pygls";
  version = "1.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "openlawlibrary";
    repo = "pygls";
    rev = "refs/tags/v${version}";
    hash = "sha256-FOuBS/UJpkYbuIu193vkSpN/77gf+UWiS5f/t8BpAk4=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    lsprotocol
    typeguard
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  # Fixes hanging tests on Darwin
  __darwinAllowLocalNetworking = true;

  preCheck = lib.optionalString stdenv.isDarwin ''
    # Darwin issue: OSError: [Errno 24] Too many open files
    ulimit -n 1024
  '';

  pythonImportsCheck = [ "pygls" ];

  meta = with lib; {
    changelog = "https://github.com/openlawlibrary/pygls/blob/${src.rev}/CHANGELOG.md";
    description = "Pythonic generic implementation of the Language Server Protocol";
    homepage = "https://github.com/openlawlibrary/pygls";
    license = licenses.asl20;
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
