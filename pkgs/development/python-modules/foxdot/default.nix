{ stdenv, buildPythonPackage, fetchPypi, tkinter, supercollider }:

buildPythonPackage rec {
  pname = "FoxDot";
  version = "0.8.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06y626kgaz1wn1qajlngihpvd4qz8m6lx6sknmjqhhrznyji58wi";
  };

  propagatedBuildInputs = [ tkinter supercollider ];

  # Requires a running SuperCollider instance
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Live coding music with SuperCollider";
    homepage = "https://foxdot.org/";
    license = licenses.cc-by-sa-40;
    maintainers = with maintainers; [ mrmebelman ];
  };
}
