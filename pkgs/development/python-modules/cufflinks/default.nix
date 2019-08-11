{ buildPythonPackage, stdenv, fetchPypi, fetchpatch
, numpy, pandas, plotly, six, colorlover
, ipython, ipywidgets, nose
}:

buildPythonPackage rec {
  pname = "cufflinks";
  version = "0.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "014098a4568199957198c0a7fe3dbeb3b4010b6de8d692a41fe3b3ac107b660e";
  };

  propagatedBuildInputs = [
    numpy pandas plotly six colorlover
    ipython ipywidgets
  ];

  patches = [
    # Plotly 3.8 compatibility. Remove with the next release. See https://github.com/santosjorge/cufflinks/pull/178
    (fetchpatch {
      url = "https://github.com/santosjorge/cufflinks/commit/cc4c23c2b45b870f6801d1cb0312948e1f73f424.patch";
      sha256 = "1psl2h7vscpzvb4idr6s175v8znl2mfhkcyhb1926p4saswmghw1";
    })
  ];

  checkInputs = [ nose ];

  checkPhase = ''
    nosetests -xv tests.py
  '';

  meta = {
    homepage = https://github.com/santosjorge/cufflinks;
    description = "Productivity Tools for Plotly + Pandas";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ globin ];
  };
}
