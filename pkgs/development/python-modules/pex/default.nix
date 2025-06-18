{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchurl,
  setuptools,
}:
let
  # 4 binaries which require vendoring, as otherwise
  # the build system behind pex will attempt to fetch
  # them during at build time
  uv-trampoline = {
    # Taken from https://github.com/pex-tool/pex/blob/2c66932d6645e8e542e5386eae08b9cc2dbb2a21/pex/windows/__init__.py#L45
    version = "0.5.29";

    aarch64-gui = fetchurl {
      url = "https://raw.githubusercontent.com/astral-sh/uv/refs/tags/${uv-trampoline.version}/crates/uv-trampoline/trampolines/uv-trampoline-aarch64-gui.exe";
      hash = "sha256-mb8x1FpyH+wy11X5YgWfqh/VUwBb62M4Zf9aFr5V4EE=";
    };

    aarch64-console = fetchurl {
      url = "https://raw.githubusercontent.com/astral-sh/uv/refs/tags/${uv-trampoline.version}/crates/uv-trampoline/trampolines/uv-trampoline-aarch64-console.exe";
      hash = "sha256-1S2aM+6CV7rKz+3ncM5X7kk7uDQeuha1+8lUEMYC75k=";
    };

    x86_64-gui = fetchurl {
      url = "https://raw.githubusercontent.com/astral-sh/uv/refs/tags/${uv-trampoline.version}/crates/uv-trampoline/trampolines/uv-trampoline-x86_64-gui.exe";
      hash = "sha256-icnp1oXrOZpc+dHTGvDbTHjr+D8M0eamvRrC9bPI/KI=";
    };

    x86_64-console = fetchurl {
      url = "https://raw.githubusercontent.com/astral-sh/uv/refs/tags/${uv-trampoline.version}/crates/uv-trampoline/trampolines/uv-trampoline-x86_64-console.exe";
      hash = "sha256-nLopBrlCMMFjkKVRlY7Ke2zFGpQOyF5mSlLs0d7+HRQ=";
    };
  };
in
buildPythonPackage rec {
  pname = "pex";
  version = "2.38.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ejd9JWmDutYpwR+KPiS90Y3XKyyOwRAMpCEN013VMdI=";
  };

  preBuild = ''
    mkdir -p pex/windows/stubs
    cp ${uv-trampoline.aarch64-gui} pex/windows/stubs/uv-trampoline-aarch64-gui.exe
    cp ${uv-trampoline.aarch64-console} pex/windows/stubs/uv-trampoline-aarch64-console.exe
    cp ${uv-trampoline.x86_64-gui} pex/windows/stubs/uv-trampoline-x86_64-gui.exe
    cp ${uv-trampoline.x86_64-console} pex/windows/stubs/uv-trampoline-x86_64-console.exe
  '';

  build-system = [ setuptools ];

  # A few more dependencies I don't want to handle right now...
  doCheck = false;

  pythonImportsCheck = [ "pex" ];

  meta = with lib; {
    description = "Python library and tool for generating .pex (Python EXecutable) files";
    homepage = "https://github.com/pantsbuild/pex";
    changelog = "https://github.com/pantsbuild/pex/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
