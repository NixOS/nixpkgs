{ stdenv, buildPythonPackage, fetchPypi, lxml, requests, tkinter }:

buildPythonPackage rec {
  pname = "fritzconnection";
  version = "0.8.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "adc629a48b50700f5478f69436e4b78c8792a9260cc674cccef15ffe68eb0643";
  };

  prePatch = ''
    substituteInPlace fritzconnection/test.py \
      --replace "from fritzconnection import" "from .fritzconnection import"
  '';

  propagatedBuildInputs = [ lxml requests tkinter ];

  meta = with stdenv.lib; {
    description = "Python-Tool to communicate with the AVM FritzBox using the TR-064 protocol";
    homepage = https://bitbucket.org/kbr/fritzconnection;
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
