{ stdenv, buildPythonPackage, fetchPypi, tkinter, supercollider }:

buildPythonPackage rec {
  pname = "FoxDot";
  version = "0.8.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c5iqdn17ip6lkf26xb1cwjvcly0448gvqmkbkvhnqy4birc8cf5";
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
