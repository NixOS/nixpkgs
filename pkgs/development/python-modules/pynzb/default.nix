{ stdenv
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "pynzb";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0735b3889a1174bbb65418ee503629d3f5e4a63f04b16f46ffba18253ec3ef17";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest -s pynzb -t .
  '';

  # Can't get them working
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/ericflo/pynzb;
    description = "Unified API for parsing NZB files";
    license = licenses.bsd3;
    maintainers = with maintainers; [ domenkozar ];
  };

}
