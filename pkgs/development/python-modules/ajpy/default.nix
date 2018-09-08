{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ajpy";
  version = "0.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a5f62b765f59ffc37e759d3f343de16cd782cc4e9e8be09c73b71dfbe383d9b";
  };

  # ajpy doesn't have tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "AJP package crafting library";
    homepage = https://github.com/hypn0s/AJPy/;
    license = licenses.lgpl2;
    maintainers = with maintainers; [ y0no ];
  };
}
