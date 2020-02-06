{ stdenv, buildPythonPackage, fetchPypi, tkinter, supercollider }:

buildPythonPackage rec {
  pname = "FoxDot";
  version = "0.8.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1k32fjlmzhhh6hvda71xqis13c3bdn7y3f5z9qqd1q410nfpzf59";
  };

  propagatedBuildInputs = [ tkinter supercollider ];

  # Requires a running SuperCollider instance
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Live coding music with SuperCollider";
    homepage = https://foxdot.org/;
    license = licenses.cc-by-sa-40;
    maintainers = with maintainers; [ mrmebelman ];
  };
}
