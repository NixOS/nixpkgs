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
  version = "0.8.12";

  src = fetchPypi {
    pname = "FoxDot";
    inherit version;
    hash = "sha256-UomZ2lWtYw5UCjnA6urNGcWMNvSdZdJOqXBNB4HhjJA=";
  };

  propagatedBuildInputs =
    [ tkinter ]
    # we currently build SuperCollider only on Linux
    # but FoxDot is totally usable on macOS with the official SuperCollider binary
    ++ lib.optionals stdenv.isLinux [ supercollider ];

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
