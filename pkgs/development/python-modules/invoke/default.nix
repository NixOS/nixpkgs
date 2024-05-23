{
  lib,
  bash,
  buildPythonPackage,
  fetchPypi,
  stdenv,
}:

buildPythonPackage rec {
  pname = "invoke";
  version = "2.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7my7EBrxqFnH/oTyomTAWQILDLf+NTX5QkMAq1aPa9U=";
  };

  postPatch = ''
    sed -e 's|/bin/bash|${bash}/bin/bash|g' -i invoke/config.py
  '';

  # errors with vendored libs
  doCheck = false;

  pythonImportsCheck = [ "invoke" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    mkdir -p $out/share/{bash-completion/completions,fish/vendor_completions.d,zsh/site-functions}
    $out/bin/inv --print-completion-script=zsh >$out/share/zsh/site-functions/_inv
    $out/bin/inv --print-completion-script=bash >$out/share/bash-completion/completions/inv.bash
    $out/bin/inv --print-completion-script=fish >$out/share/fish/vendor_completions.d/inv.fish
  '';

  meta = with lib; {
    changelog = "https://www.pyinvoke.org/changelog.html";
    description = "Pythonic task execution";
    homepage = "https://www.pyinvoke.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
