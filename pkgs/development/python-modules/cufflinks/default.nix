{ buildPythonPackage, stdenv, fetchPypi, pandas, plotly, colorlover
}:

buildPythonPackage rec {
  pname = "cufflinks";
  version = "0.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "59f1bae67aaa5042c8f9f94caba44b9b8e6e530ce9e81f6e06b643aca253d2f4";
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
