{
  lib,
  fetchFromGitHub,
  writeShellScriptBin,
  plover,
  python3Packages,
  pkginfo,
  packaging,
  psutil,
  pygments,
  readme-renderer,
  requests-cache,
  requests-futures,
  # Qt
  pyqt,
  qtbase,
  wrapQtAppsHook,
}:

(plover.override {
  inherit wrapQtAppsHook pyqt;
}).overridePythonAttrs
  (oldAttrs: rec {
    version = "5.0.0.dev2";

    src = fetchFromGitHub {
      owner = "openstenoproject";
      repo = "plover";
      tag = "v${version}";
      hash = "sha256-PZwxVrdQPhgbj+YmWZIUETngeJGs6IQty0hY43tLQO0=";
    };

    # pythonRelaxDeps seemingly doesn't work here
    postPatch = oldAttrs.postPatch + ''
      sed -i /PySide6-Essentials/d pyproject.toml
    '';

    build-system = oldAttrs.build-system ++ [
      # Replacement for missing pyside6-essentials tools,
      # workaround for https://github.com/NixOS/nixpkgs/issues/277849.
      # Ideally this would be solved in pyside6 itself but I spent four
      # hours trying to untangle its build system before giving up. If
      # anyone wants to spend the time fixing it feel free to request
      # me (@Pandapip1) as a reviewer.
      (writeShellScriptBin "pyside6-uic" ''
        exec ${qtbase}/libexec/uic -g python "$@"
      '')
      (writeShellScriptBin "pyside6-rcc" ''
        exec ${qtbase}/libexec/rcc -g python "$@"
      '')
    ];

    dependencies =
      oldAttrs.dependencies
      ++ [
        packaging
        pkginfo
        psutil
        pygments
        qtbase
        readme-renderer
        requests-cache
        requests-futures
      ]
      ++ readme-renderer.optional-dependencies.md;

    meta.description = oldAttrs.meta.description + " (Development version)";
  })
