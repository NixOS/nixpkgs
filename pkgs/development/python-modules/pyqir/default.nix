{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, rustPlatform
, libxml2
, llvm # LLVM version provided must strictly match pyqir support list
}:
let
  llvm-v-major = lib.versions.major llvm.version;
  llvm-v-minor = builtins.substring 0 1 (lib.versions.minor llvm.version);
in
buildPythonPackage rec {
  pname = "pyqir";
  version = "0.8.2";

  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "qir-alliance";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XqNQ2NUP4KzDMtLeREg+A4gT/G2vd1YnaMP+oNMKoIU=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-frdmi94zuZgBC5enou6WjMiupAY+KItUfvYDuIavZKk=";
  };

  buildAndTestSubdir = "pyqir";

  nativeBuildInputs = with rustPlatform; [ cargoSetupHook maturinBuildHook ];

  buildInputs = [ llvm libxml2.dev ];

  maturinBuildFlags = "-F llvm${llvm-v-major}-${llvm-v-minor}";

  preConfigure = ''
    export LLVM_SYS_${llvm-v-major}${llvm-v-minor}_PREFIX=${llvm.dev}
  '';

  pythonImportsCheck = [ "pyqir" ];

  passthru.llvm = llvm;

  meta = with lib; {
    description = "API for parsing and generating Quantum Intermediate Representation (QIR)";
    homepage = "https://github.com/qir-alliance/pyqir";
    license = licenses.mit;
    maintainers = with maintainers; [ evilmav ];
  };
}
