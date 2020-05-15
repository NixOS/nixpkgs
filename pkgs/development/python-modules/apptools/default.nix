{ lib, fetchPypi, buildPythonPackage, fetchpatch
, configobj, six, traitsui
, nose, tables, pandas
}:

buildPythonPackage rec {
  pname = "apptools";
  version = "4.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10h52ibhr2aw076pivqxiajr9rpcr1mancg6xlpxzckcm3if02i6";
  };

  # PyTables issue; should be merged in next post-4.5.0 release (#117)
  patches = [ (fetchpatch {
      url = "https://github.com/enthought/apptools/commit/3734289d1a0ebd8513fa67f75288add31ed0113c.patch";
      sha256 = "001012q1ib5cbib3nq1alh9ckzj588bfrywr8brkd1f6y1pgvngk";
    })
  ];

  propagatedBuildInputs = [ configobj six traitsui ];

  checkInputs = [
    nose
    tables
    pandas
  ];

  doCheck = true;
  checkPhase = ''HOME=$TMP nosetests'';

  meta = with lib; {
    description = "Set of packages that Enthought has found useful in creating a number of applications.";
    homepage = "https://github.com/enthought/apptools";
    maintainers = with maintainers; [ knedlsepp ];
    license = licenses.bsdOriginal;
  };
}
