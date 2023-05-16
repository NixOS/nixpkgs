<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchFromGitHub
, git
, jinja2
, pythonOlder
, riscv-config
, riscv-isac
=======
{ buildPythonPackage
, fetchFromGitHub
, lib
, git
, riscv-isac
, riscv-config
, jinja2
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "riscof";
  version = "1.25.3";
<<<<<<< HEAD
  format = "setuptools";

  disabled = pythonOlder "3.6";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "riscv-software-src";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-ToI2xI0fvnDR+hJ++T4ss5X3gc4G6Cj1uJHx0m2X7GY=";
  };

<<<<<<< HEAD
  patches = [
    # riscof copies a template directory from the store, but breaks because it
    # doesn't change permissions and expects it to be writeable
    ./make_writeable.patch
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "import pip" ""
    substituteInPlace riscof/requirements.txt \
      --replace "GitPython==3.1.17" "GitPython"
  '';

  propagatedBuildInputs = [
    riscv-isac
    riscv-config
    jinja2
  ];

  pythonImportsCheck = [
    "riscof"
  ];

  # No unitests available
  doCheck = false;

  meta = with lib; {
    description = "RISC-V Architectural Test Framework";
    homepage = "https://github.com/riscv-software-src/riscof";
    changelog = "https://github.com/riscv-software-src/riscof/blob/${version}/CHANGELOG.md";
=======
  postPatch = "substituteInPlace riscof/requirements.txt --replace 'GitPython==3.1.17' GitPython";

  propagatedBuildInputs = [ riscv-isac riscv-config jinja2 ];

  patches = [
    # riscof copies a template directory from the store, but breaks because it doesn't change permissions and expects it to be writeable
    ./make_writeable.patch
  ];

  meta = with lib; {
    homepage = "https://github.com/riscv-software-src/riscof";
    description = "RISC-V Architectural Test Framework";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd3;
  };
}
