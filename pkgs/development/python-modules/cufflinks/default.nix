{ buildPythonPackage, stdenv, fetchPypi, pandas, plotly, colorlover
}:

buildPythonPackage rec {
  pname = "cufflinks";
  version = "0.12.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04ninvwm6277n3hqc17ririss90cd832wza3q3vf115rrrds3xyy";
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
