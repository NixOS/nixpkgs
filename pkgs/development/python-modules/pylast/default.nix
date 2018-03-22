{ stdenv, buildPythonPackage, fetchPypi, certifi, six }:

buildPythonPackage rec {
  pname = "pylast";
  version = "2.1.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b9b51dc40a7d3ac3eee17ab5b462b8efb7f2c2ff195261ea846ae4e1168e1c5b";
  };

  propagatedBuildInputs = [ certifi six ];

  # tests require last.fm credentials
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/pylast/pylast;
    description = "A python interface to last.fm (and compatibles)";
    license = licenses.asl20;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
