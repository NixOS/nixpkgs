{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyexcel-io,
  odfpy,
  pynose,
  pyexcel,
  pyexcel-xls,
  psutil,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyexcel-ods";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f61b56515fd4ccd4687f0a112422f74ce8535247ad2da49db90038d7e3ed397c";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    pyexcel-io
    odfpy
  ];

  nativeCheckInputs = [
    pynose
    pyexcel
    pyexcel-xls
    psutil
  ];

  checkPhase = ''
    runHook preCheck
    nosetests
    runHook postCheck
  '';

  meta = {
    description = "Plug-in to pyexcel providing the capbility to read, manipulate and write data in ods formats using odfpy";
    homepage = "http://docs.pyexcel.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
  };
}
