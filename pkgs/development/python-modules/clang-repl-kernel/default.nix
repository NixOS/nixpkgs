{
  lib,
  buildPythonPackage,
  fetchPypi,
  python, # the interpreter used by buildPythonPackage
  hatchling,
  pythonOlder,
  pytest,
  ipykernel,
  requests,
  tqdm,
  llvmPackages,
}:

buildPythonPackage rec {
  pname = "clang-repl-kernel";
  version = "1.6.27";
  pyproject = true;

  src = fetchPypi {
    pname = "clang_repl_kernel";
    inherit version;
    hash = "sha256-r7zOtD8AV69Hnz8dkvgmiFFSxUcQI5F2Hn8SILPKgj8=";
  };

  build-system = [
    hatchling
  ];

  # Requires Python >= 3.11
  disabled = pythonOlder "3.11";

  propagatedBuildInputs = [
    llvmPackages.clang-tools
  ];

  dependencies = [
    ipykernel
    pytest
    requests
    tqdm
  ];

  # Upstream’s hatch build hook tries to download toolchain bundles.
  # We replace hatch_build.py with a no-op so no network is used during build.
  postPatch = ''
        if [ -f hatch_build.py ]; then
          cat > hatch_build.py <<'PY'
    from hatchling.builders.hooks.plugin.interface import BuildHookInterface
    class CustomBuildHook(BuildHookInterface):
        def initialize(self, version, build_data):
            # Nixpkgs: disable kernelspec/toolchain installation at build time
            # (we install a kernelspec in postInstall below and use system clang-repl)
            pass
    PY
        fi
  '';

  # No upstream test suite worth running here
  doCheck = false;

  # Install a kernelspec that relies on system clang-repl and our python
  postInstall = ''
        ksdir="$out/share/jupyter/kernels/clang-repl"
        mkdir -p "$ksdir"

        cat > "$ksdir/kernel.json" <<EOF
    {
      "argv": ["${python.interpreter}", "-m", "clang_repl_kernel", "-f", "{connection_file}"],
      "display_name": "Clang-Repl (C++20)",
      "language": "c++",
      "env": {
        "PATH": "${llvmPackages.clang-tools}/bin:\$PATH"
      }
    }
    EOF
  '';

  # Light sanity check: module import
  pythonImportsCheck = [ "clang_repl_kernel" ];

  meta = {
    description = "Jupyter kernel for C/C++ using LLVM's clang-repl";
    homepage = "https://pypi.org/project/clang-repl-kernel/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ romildo ];
    platforms = lib.platforms.unix;
  };
}
