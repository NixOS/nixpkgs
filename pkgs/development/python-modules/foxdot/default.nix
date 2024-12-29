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
    sha256 = "528999da55ad630e540a39c0eaeacd19c58c36f49d65d24ea9704d0781e18c90";
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
