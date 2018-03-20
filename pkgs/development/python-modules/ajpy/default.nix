{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ajpy";
  version = "0.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "740e7daf728ba58dabaf4af2c4305262eb207a6e41791424a146a21396ceb9ad";
  };

  # ajpy doesn't have tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "AJP package crafting library";
    homepage = "https://github.com/hypn0s/AJPy/";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ y0no ];
  };
}
