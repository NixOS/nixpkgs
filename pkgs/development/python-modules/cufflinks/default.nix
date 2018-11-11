{ buildPythonPackage, stdenv, fetchPypi, pandas, plotly, colorlover
}:

buildPythonPackage rec {
  pname = "cufflinks";
  version = "0.14.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4188324361cc584214150aadaeb28ed07e9d150adb714b53c5f09d5b3fcdd28a";
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
