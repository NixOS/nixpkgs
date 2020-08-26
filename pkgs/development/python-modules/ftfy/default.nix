{ stdenv
, buildPythonPackage
, isPy3k
, fetchPypi
, html5lib
, wcwidth
, setuptools
, pytest
}:

buildPythonPackage rec {
  pname = "ftfy";
  version = "5.8";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "081p5z20dirrf1i3nshylc31qd5mbxibjc7gzj8x4isbiizpdisi";
  };

  propagatedBuildInputs = [
    html5lib
    wcwidth
    setuptools
  ];

  checkInputs = [
    pytest
  ];

  # We suffix PATH like this because the tests want the ftfy executable
  checkPhase = ''
    PATH=$out/bin:$PATH pytest
  '';

  meta = with stdenv.lib; {
    description = "Given Unicode text, make its representation consistent and possibly less broken";
    homepage = "https://github.com/LuminosoInsight/python-ftfy";
    license = licenses.mit;
    maintainers = with maintainers; [ sdll aborsu ];
  };
}
