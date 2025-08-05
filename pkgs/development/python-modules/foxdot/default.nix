{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  tkinter,
  supercollider,
}:

buildPythonPackage rec {
  pname = "foxdot";
  version = "0.9.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "FoxDot";
    inherit version;
    sha256 = "sha256-9dIaqrGcYpZeWlRlymRvG9YnTRav0zktfmUpFBlN/7E=";
  };

  propagatedBuildInputs = [
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
