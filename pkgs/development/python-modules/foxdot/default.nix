{ stdenv, buildPythonPackage, fetchPypi, tkinter, supercollider }:

buildPythonPackage rec {
  pname = "FoxDot";
  version = "0.8.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00yqpkv7cxwk301cyiwjzr9yfq8hpnhqyspw3z874ydrl3cmssdb";
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
