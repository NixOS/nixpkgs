{ lib
, buildPythonPackage
, fetchPypi
, pyexcel-io
, odfpy
, nose
, pyexcel
, pyexcel-xls
, psutil
}:

buildPythonPackage rec {
  pname = "pyexcel-ods";
  version = "0.5.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "O+Uv2KrdvYvJKG9+sUj0VT1MlyUtaVw6nse5XmZmoiM=";
  };

  propagatedBuildInputs = [
    pyexcel-io
    odfpy
  ];

  checkInputs = [
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
    maintainers = with lib.maintainers; [ jtojnar ];
  };
}
