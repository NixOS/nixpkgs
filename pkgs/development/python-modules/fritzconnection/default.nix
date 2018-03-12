{ stdenv, buildPythonPackage, fetchPypi, lxml, requests, tkinter }:

buildPythonPackage rec {
  pname = "fritzconnection";
  version = "0.6.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14g3sxprq65lxbgkf3rjgb1bjqnj2jc5p1swlq9sk9gwnl6ca3ds";
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
