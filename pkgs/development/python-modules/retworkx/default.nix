{ lib
, buildPythonPackage
, pythonOlder
, pythonAtLeast
, isPy37
, isPy38
, fetchFromGitHub
, fetchPypi
  # Check inputs
, pytestCheckHook
}:

let
  rx-version = "0.3.3";
  wheel-args = if isPy37 then
      { python = "cp37"; sha256 = "1gbz7sh9i4h41xs9c40lixfdigmvfykkgxgzwsrs8v0smx20dczy"; }
    else if isPy38 then
      { python = "cp38"; sha256 = "09xxgp4ac4q6mfkj6lsqqfrzz1cb02vxy7wlv0bq3z2hd0jcanxk"; }
    else throw "python version & hash not included. Override attribute `wheel-args` with version & hash at https://pypi.org/project/retworkx";

  github-source = fetchFromGitHub {
    owner = "Qiskit";
    repo = "retworkx";
    rev = rx-version;
    sha256 = "160w5vkzrl5rzcrdwhjq820i5lmc527m6hg0kxx0k6n2bz9qn26g";
  };
in
buildPythonPackage rec {
  pname = "retworkx";
  version = rx-version;
  format = "wheel";

  disabled = pythonOlder "3.5" || pythonAtLeast "3.9"; # compiled versions only included for 3.5 <= py <= 3.8

  src = fetchPypi {
    inherit pname version format;
    inherit (wheel-args) python sha256;
    abi = if pythonOlder "3.8" then "${wheel-args.python}m" else wheel-args.python;
    platform = "manylinux2010_x86_64"; # i686, aarch64, and ppc64 also available, restricting to x86 for simplicity
  };

  pythonImportsCheck = [ "retworkx" ];

  checkInputs = [ pytestCheckHook ];
  preCheck = ''
    pushd $(mktemp -d)
    cp -r ${github-source}/$sourceRoot/tests .
  '';
  postCheck = "popd";

  meta = with lib; {
    description = "A python graph library implemented in Rust.";
    homepage = "https://retworkx.readthedocs.io/en/latest/index.html";
    downloadPage = "https://github.com/Qiskit/retworkx/releases";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
    platforms = platforms.x86_64;
  };
}
