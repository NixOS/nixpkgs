{ buildPythonPackage, stdenv, fetchPypi, pandas, plotly, colorlover
}:

buildPythonPackage rec {
  pname = "cufflinks";
  version = "0.14.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "304f9a30b753e36a9d398133543c9b48214fcf0535d971871894fc3058799c5f";
  };

  propagatedBuildInputs = [ pandas plotly colorlover ];

  # tests not included in archive
  doCheck = false;

  meta = {
    homepage = https://github.com/santosjorge/cufflinks;
    description = "Productivity Tools for Plotly + Pandas";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ globin ];
  };
}
