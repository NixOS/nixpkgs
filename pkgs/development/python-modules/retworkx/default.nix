{ stdenv
, lib
, rustPlatform
, buildPythonPackage
, fetchFromGitHub
# , fetchPypi
# , setuptools-rust
  # Check inputs
, pytestCheckHook
}:

let
  pn = "retworkx";
  v = "0.3.3";
  src-raw = fetchFromGitHub {
    owner = "Qiskit";
    repo = "retworkx";
    rev = v;
    sha256 = "160w5vkzrl5rzcrdwhjq820i5lmc527m6hg0kxx0k6n2bz9qn26g";
  };

  retworkx-rs = rustPlatform.buildRustPackage {
    pname = pn;
    version = v;

    src = src-raw;
    cargoPatches = [ ./cargo-lock.patch ];
    cargoSha256 = "1hkidvyyw2p75x1xk98fl023sm1fpjihssqsg839bi5m09hj0sd4";
  };

in
buildPythonPackage rec {
  pname = "retworkx";
  version = "0.3.3";
  # format = "wheel";

  src = src-raw;
  # src = fetchPypi {
  #   inherit pname version format;
  #   python = "cp37";
  #   abi = "cp37m";
  #   platform = "manylinux2010_x86_64";
  #   sha256 = "1gbz7sh9i4h41xs9c40lixfdigmvfykkgxgzwsrs8v0smx20dczy";
  # };

  buildInputs = [
    retworkx-rs
  ];

  propagatedBuildInputs = [

  ];

  pythonImportsCheck = [ "retworkx" ];

  checkInputs = [ pytestCheckHook ];
  dontUseSetuptoolsCheck = true;

  meta = with lib; {
    description = "A python graph library implemented in Rust.";
    homepage = "https://retworkx.readthedocs.io/en/latest/index.html";
    downloadPage = "https://github.com/Qiskit/retworkx/releases";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
