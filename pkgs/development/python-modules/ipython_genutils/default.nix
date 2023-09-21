{ lib
, buildPythonPackage
, fetchPypi
, nose
, glibcLocales
}:

buildPythonPackage rec {
  pname = "ipython_genutils";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eb2e116e75ecef9d4d228fdc66af54269afa26ab4463042e33785b887c628ba8";
  };

  nativeCheckInputs = [ nose glibcLocales ];

  checkPhase = ''
    LC_ALL="en_US.UTF-8" nosetests -v ipython_genutils/tests
  '';

  meta = {
    description = "Vestigial utilities from IPython";
    homepage = "https://ipython.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
