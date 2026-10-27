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
  version = "0.5.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dVJQ28Z+fohSQOk0rXCCKrhYmBL7QB/CGO/9pBhabFE=";
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

  meta = {
    homepage = "https://functiontrace.com";
    description = "Python module for Functiontrace";
    license = lib.licenses.prosperity30;
    maintainers = with lib.maintainers; [
      mathiassven
      tehmatt
    ];
  };
}
