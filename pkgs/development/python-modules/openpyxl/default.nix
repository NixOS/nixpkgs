{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytest
, jdcal
, et_xmlfile
, lxml
}:

buildPythonPackage rec {
  pname = "openpyxl";
  version = "3.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pvWXdBjv87LVUA1U2dtQyCd6NoQ29OT43bG+NCKHAYQ=";
  };

  nativeCheckInputs = [ pytest ];
  propagatedBuildInputs = [ jdcal et_xmlfile lxml ];

  postPatch = ''
    # LICENSE.rst is missing, and setup.cfg currently doesn't contain anything useful anyway
    # This should likely be removed in the next update
    rm setup.cfg
  '';

  # Tests are not included in archive.
  # https://bitbucket.org/openpyxl/openpyxl/issues/610
  doCheck = false;

  meta = with lib; {
    description = "A Python library to read/write Excel 2007 xlsx/xlsm files";
    homepage = "https://openpyxl.readthedocs.org";
    changelog = "https://foss.heptapod.net/openpyxl/openpyxl/-/blob/${version}/doc/changes.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ lihop ];
  };
}
