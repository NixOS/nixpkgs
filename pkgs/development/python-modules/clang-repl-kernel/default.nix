{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  ipykernel,
  pexpect,
  llvmPackages,
}:

buildPythonPackage {
  pname = "clang-repl-kernel";
  version = "unstable-2025-05-05";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pmanstet";
    repo = "clang_repl_kernel";
    rev = "0dc16d21abd6f0dd2f7e3a728e90a9dcc7d3e949";
    hash = "sha256-Bv8a2rpPXceaHxXWTJ/80vIckfytez9c3Myqnu4r4l4=";
  };

  build-system = [ hatchling ];

  dependencies = [
    ipykernel
    pexpect
  ];

  propagatedBuildInputs = [ llvmPackages.clang-tools ];

  postPatch = ''
    # Drop heavy, UI-only deps from project dependencies
    substituteInPlace pyproject.toml \
      --replace-fail '"jupyter-console",' "" \
      --replace-fail '"notebook",' ""
  '';

  postInstall = ''
      # Nix-wrap will add PATH/PYTHONPATH automatically to Python scripts in $out/bin.

      mkdir -p "$out/bin"

      cat > "$out/bin/clang-repl-kernel-start" <<'SH'
    #!/usr/bin/env python3
    import sys
    import runpy

    # Reconstruct sys.argv for the target module
    sys.argv = ['clang_repl', '-f'] + sys.argv[1:]

    # Programmatically execute `python -m clang_repl`
    runpy.run_module('clang_repl', run_name='__main__')
    SH

      chmod +x $out/bin/clang-repl-kernel-start

      mkdir -p $out/share/jupyter/kernels/clang-repl

      cat > $out/share/jupyter/kernels/clang-repl/kernel.json <<EOF
    {
      "argv": ["$out/bin/clang-repl-kernel-start", "{connection_file}"],
      "display_name": "Clang-Repl (C++20)",
      "language": "c++"
    }
    EOF
  '';

  pythonImportsCheck = [ "clang_repl" ];

  meta = {
    description = "Minimal Jupyter kernel that wraps LLVM's clang-repl";
    homepage = "https://github.com/pmanstet/clang_repl_kernel";
    license = lib.licenses.cc0;
    maintainers = [ lib.maintainers.romildo ];
    platforms = lib.platforms.unix;
  };
}
