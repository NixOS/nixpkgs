{ lib
, bash
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, stdenv
=======
, pythonOlder
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "invoke";
  version = "2.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-erXdnNdreH1WCnixqYENJSNnq1lZhcUGEnAr4h1nHdc=";
  };

  postPatch = ''
    sed -e 's|/bin/bash|${bash}/bin/bash|g' -i invoke/config.py
  '';

  # errors with vendored libs
  doCheck = false;

  pythonImportsCheck = [
    "invoke"
  ];

<<<<<<< HEAD
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    mkdir -p $out/share/{bash-completion/completions,fish/vendor_completions.d,zsh/site-functions}
    $out/bin/inv --print-completion-script=zsh >$out/share/zsh/site-functions/_inv
    $out/bin/inv --print-completion-script=bash >$out/share/bash-completion/completions/inv.bash
    $out/bin/inv --print-completion-script=fish >$out/share/fish/vendor_completions.d/inv.fish
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Pythonic task execution";
    homepage = "https://www.pyinvoke.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
