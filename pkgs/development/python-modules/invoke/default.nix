{
  lib,
  stdenv,
  bash,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "invoke";
  version = "3.0.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Q3tqYiIjgkOAv7TmT2EnEaa2SMeV9WXvyGJa9m+1fww=";
  };

  postPatch = ''
    sed -e 's|/bin/bash|${bash}/bin/bash|g' -i invoke/config.py
  '';

  build-system = [ setuptools ];

  # errors with vendored libs
  doCheck = false;

  pythonImportsCheck = [ "invoke" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    mkdir -p $out/share/{bash-completion/completions,fish/vendor_completions.d,zsh/site-functions}
    $out/bin/inv --print-completion-script=zsh >$out/share/zsh/site-functions/_inv
    $out/bin/inv --print-completion-script=bash >$out/share/bash-completion/completions/inv.bash
    $out/bin/inv --print-completion-script=fish >$out/share/fish/vendor_completions.d/inv.fish
  '';

  meta = {
    description = "Pythonic task execution";
    changelog = "https://www.pyinvoke.org/changelog.html";
    homepage = "https://www.pyinvoke.org/";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
