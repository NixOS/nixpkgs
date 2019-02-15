{ lib
, buildPythonPackage
, fetchPypi
, nose

}:

buildPythonPackage rec {
  pname = "ipython_genutils";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eb2e116e75ecef9d4d228fdc66af54269afa26ab4463042e33785b887c628ba8";
  };

  checkInputs = [ nose  ];

  checkPhase = ''
  '';

  meta = {
    description = "Vestigial utilities from IPython";
    homepage = http://ipython.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}