{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pytest
, jdcal
, et_xmlfile
, lxml
}:

buildPythonPackage rec {
  pname = "openpyxl";
  version = "3.0.7";
  disabled = isPy27; # 2.6.4 was final python2 release

  src = fetchPypi {
    inherit pname version;
    sha256 = "6456a3b472e1ef0facb1129f3c6ef00713cebf62e736cd7a75bcc3247432f251";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ jdcal et_xmlfile lxml ];

  postPatch = ''
    # LICENSE.rst is missing, and setup.cfg currently doesn't contain anything useful anyway
    # This should likely be removed in the next update
    rm setup.cfg
  '';

  # Tests are not included in archive.
  # https://bitbucket.org/openpyxl/openpyxl/issues/610
  doCheck = false;

  meta = {
    description = "A Python library to read/write Excel 2007 xlsx/xlsm files";
    homepage = "https://openpyxl.readthedocs.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lihop sjourdois ];
  };
}
