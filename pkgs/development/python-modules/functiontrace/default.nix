{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  toml,
  functiontrace-server,
}:

buildPythonPackage rec {
  pname = "functiontrace";
  version = "0.5.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yRzcg8BDuwF74J2EYa/3GMkTaRGsx0WyDIQEWHwj12M=";
  };

  nativeBuildInputs = [
    setuptools
    toml
  ];

  pythonImportsCheck = [ "functiontrace" ];

  # `functiontrace` needs `functiontrace-server` in its path.
  # Technically we also need this when running via a Python import, such as for
  # `python3 -m functiontrace`, but that's a less common use-case.
  postFixup = ''
    wrapProgram $out/bin/functiontrace \
      --prefix PATH : ${lib.makeBinPath [ functiontrace-server ]}
  '';

  meta = with lib; {
    homepage = "https://functiontrace.com";
    description = "Python module for Functiontrace";
    license = licenses.prosperity30;
    maintainers = with maintainers; [
      mathiassven
      tehmatt
    ];
  };
}
