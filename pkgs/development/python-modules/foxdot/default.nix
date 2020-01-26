{ stdenv, buildPythonPackage, fetchPypi, tkinter, supercollider }:

buildPythonPackage rec {
  pname = "FoxDot";
  version = "0.8.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8b6d810f5389692c45d236dec89cecc4ff32ad053e4c878c91363acfa4508639";
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
