{ lib, fetchFromGitHub, buildPythonPackage
, pytest }:

buildPythonPackage rec {
  pname = "pytest-ordering";
  version = "unstable-2019-06-19";

  # Pypi lacks tests/
  # Resolves PytestUnknownMarkWarning from pytest
  src = fetchFromGitHub {
    owner = "ftobia";
    repo = pname;
    rev = "492697ee26633cc31d329c1ceaa468375ee8ee9c";
    sha256 = "1xim0kj5g37p1skgvp8gdylpx949krmx60w3pw6j1m1h7sakmddn";
  };

  nativeCheckInputs = [
    pytest
  ];

  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    homepage = "https://github.com/ftobia/pytest-ordering";
    description = "Pytest plugin to run your tests in a specific order";
    license = licenses.mit;
    broken = true;  # See https://github.com/NixOS/nixpkgs/pull/122264
    maintainers = with maintainers; [ eadwu ];
  };
}
