{ stdenv, buildPythonPackage, fetchPypi,
  click
}:

buildPythonPackage rec {
  pname = "cligj";
  version = "0.4.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0m1zic66nay2rymfa9krd3jfpyajxjnbmzw7c2q764aw9ychgb8j";
  };

  propagatedBuildInputs = [
    click
  ];

  meta = with stdenv.lib; {
    description = "Click params for commmand line interfaces to GeoJSON";
    homepage = https://github.com/mapbox/cligj;
    license = licenses.bsd3;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
