{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "deluge-client";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "048zfidv08sr4hivdd3xxf1pywhqbnszj5qcn51h2f4y1588fhpf";
  };

  # it will try to connect to a running instance
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Lightweight pure-python rpc client for deluge";
    homepage = https://github.com/JohnDoee/deluge-client;
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
