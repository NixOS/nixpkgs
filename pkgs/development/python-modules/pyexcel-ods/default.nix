{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyexcel-io,
  odfpy,
  nose,
  pyexcel,
  pyexcel-xls,
  psutil,
}:

buildPythonPackage rec {
  pname = "pyexcel-ods";
  version = "0.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f61b56515fd4ccd4687f0a112422f74ce8535247ad2da49db90038d7e3ed397c";
  };

  propagatedBuildInputs = [
    pyexcel-io
    odfpy
  ];

  nativeCheckInputs = [
    nose
    pyexcel
    pyexcel-xls
    psutil
  ];

  checkPhase = "nosetests";

  meta = {
    description = "Plug-in to pyexcel providing the capbility to read, manipulate and write data in ods formats using odfpy";
    homepage = "http://docs.pyexcel.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
  };
}
