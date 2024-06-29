{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  verilog,
  ghdl,
  pytest,
  pytest-xdist,
}:

buildPythonPackage rec {
  pname = "myhdl";
  # The stable version is from 2019 and it doesn't pass tests
  version = "unstable-2022-04-26";
  format = "setuptools";
  # The pypi src doesn't contain the ci script used in checkPhase
  src = fetchFromGitHub {
    owner = "myhdl";
    repo = "myhdl";
    rev = "1a4f5cd4e9de2e7bbf1053c3c2bc9526b5cc524a";
    hash = "sha256-Tgoem88Y6AhlCKVhMm0Khg6GPcrEktYOqV8xcMaNkl4=";
  };

  nativeCheckInputs = [
    pytest
    pytest-xdist
    verilog
    ghdl
  ];
  passthru = {
    # If using myhdl as a dependency, use these if needed and not ghdl and
    # verlog from all-packages.nix
    inherit ghdl verilog;
  };
  checkPhase = ''
    runHook preCheck

    for target in {core,iverilog,ghdl}; do
      env CI_TARGET="$target" bash ./scripts/ci.sh
    done;

    runHook postCheck
  '';

  meta = with lib; {
    description = "Free, open-source package for using Python as a hardware description and verification language";
    homepage = "https://www.myhdl.org/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ doronbehar ];
  };
}
