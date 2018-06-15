{ buildPythonPackage, stdenv, fetchPypi, pandas, plotly, colorlover
}:

buildPythonPackage rec {
  pname = "cufflinks";
  version = "0.12.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8f11e4b6326cc5b2a18011c09fb64f178ba21002f337fd305f64818012a6c679";
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
