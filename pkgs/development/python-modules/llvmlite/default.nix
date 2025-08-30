{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  isPyPy,
  pythonAtLeast,

  setuptools,

  cmake,
  ninja,

  llvm_20,
  libxml2,

  # tests
  pytestCheckHook,

  withStaticLLVM ? true,
}:

let
  llvm = llvm_20;
in

buildPythonPackage rec {
  pname = "llvmlite";
  version = "0.45.0-rc1";
  pyproject = true;

  disabled = isPyPy || pythonAtLeast "3.14";

  src = fetchFromGitHub {
    owner = "numba";
    repo = "llvmlite";
    rev = "1f6b86481d44d818e30143f7d3351da74f5c383f";
    hash = "sha256-YC5DiOFJQU3B1XNyhJq1G3INzk5g5xVlDcw1qYLUfCM=";
    postFetch = ''
      sed -i 's/git_refnames = "[^"]*"/git_refnames = " (tag: v0.45.0-rc1)"/' $out/llvmlite/_version.py
    '';
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [ llvm ] ++ lib.optionals withStaticLLVM [ libxml2.dev ];

  nativeCheckInputs = [ pytestCheckHook ];

  dontUseCmakeConfigure = true;

  # https://github.com/NixOS/nixpkgs/issues/255262
  preCheck = ''
    cd $out
  '';

  env.LLVMLITE_SHARED = !withStaticLLVM;

  passthru = lib.optionalAttrs (!withStaticLLVM) { inherit llvm; };

  meta = {
    changelog = "https://github.com/numba/llvmlite/blob/v${version}/CHANGE_LOG";
    description = "Lightweight LLVM python binding for writing JIT compilers";
    downloadPage = "https://github.com/numba/llvmlite";
    homepage = "http://llvmlite.pydata.org/";
    license = lib.licenses.bsd2;
  };
}
