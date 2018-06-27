{ stdenv, fetchurl, buildPythonPackage, isPy3k }:

buildPythonPackage rec {
  pname = "Pyro";
  version = "3.16";
  name = pname + "-" + version;

  disabled = isPy3k;

  src = fetchurl {
    url = "mirror://pypi/P/Pyro/${name}.tar.gz";
    sha256 = "1bed508453ef7a7556b51424a58101af2349b662baab7e7331c5cb85dbe7e578";
  };

  meta = with stdenv.lib; {
    description = "Distributed object middleware for Python (IPC/RPC)";
    homepage = https://pythonhosted.org/Pyro/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
