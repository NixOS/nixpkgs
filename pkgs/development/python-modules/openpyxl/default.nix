{ lib
, buildPythonPackage
, fetchPypi
, pytest
, jdcal
, et_xmlfile
, lxml
}:

buildPythonPackage rec {
  pname = "openpyxl";
  version = "2.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "70da6b45a5925285b6a3d93570b45f4402eb2d335740163a58eef533b139565c";
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
    homepage = https://openpyxl.readthedocs.org;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lihop sjourdois ];
  };
}