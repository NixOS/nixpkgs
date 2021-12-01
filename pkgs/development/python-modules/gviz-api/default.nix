{ lib, fetchPypi, buildPythonPackage
, six
}:

buildPythonPackage rec {
  pname = "gviz_api";
  version = "1.9.0";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "1yag559lpmwfdxpxn679a6ajifcbpgljr5n6k5b7rrj38k2xq7jg";
  };

  propagatedBuildInputs = [
    six
  ];

  meta = with lib; {
    description = "Python API for Google Visualization";
    homepage = "https://developers.google.com/chart/interactive/docs/dev/gviz_api_lib";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
