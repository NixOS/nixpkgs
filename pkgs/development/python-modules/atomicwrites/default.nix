{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "atomicwrites";
  version = "0.1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08s05h211r07vs66r4din3swrbzb344vli041fihpg34q3lcxpvw";
  };

  meta = with stdenv.lib; {
    description = "Atomic file writes on POSIX";
    homepage = https://pypi.python.org/pypi/atomicwrites;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
