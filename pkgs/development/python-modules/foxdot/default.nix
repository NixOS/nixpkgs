{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  tkinter,
  supercollider,
}:

buildPythonPackage rec {
  pname = "foxdot";
  version = "0.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9dIaqrGcYpZeWlRlymRvG9YnTRav0zktfmUpFBlN/7E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    tkinter
  ]
  # we currently build SuperCollider only on Linux
  # but FoxDot is totally usable on macOS with the official SuperCollider binary
  ++ lib.optionals stdenv.hostPlatform.isLinux [ supercollider ];

  # Requires a running SuperCollider instance
  doCheck = false;

  meta = with lib; {
    description = "Live coding music with SuperCollider";
    mainProgram = "FoxDot";
    homepage = "https://foxdot.org/";
    license = licenses.cc-by-sa-40;
    maintainers = with maintainers; [ mrmebelman ];
  };
}
