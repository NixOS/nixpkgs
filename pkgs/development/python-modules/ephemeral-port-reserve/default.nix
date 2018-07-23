{ stdenv, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  version = "1.1.0";
  pname = "ephemeral_port_reserve";

  src = fetchPypi {
    inherit pname version;
    sha256 = "28790de943c1bceaf33e0f29eda3533e91231e42e1da683eabc0ae8e2498d070";
  };

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ jb55 ];
    platforms = platforms.unix;
    description = "Find an unused port, reliably";
  };
}
