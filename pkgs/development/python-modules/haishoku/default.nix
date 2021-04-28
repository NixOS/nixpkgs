{ lib, buildPythonPackage, fetchPypi, pillow }:

buildPythonPackage rec {
  pname = "haishoku";
  version = "1.1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1m6bzxlm4pfdpjr827k1zy9ym3qn411lpw5wiaqq2q2q0d6a3fg4";
  };

  propagatedBuildInputs = [ pillow ];

  meta = with lib; {
    description = "Tool for grabbing dominant color palette from images";
    homepage = "https://github.com/LanceGin/haishoku";
    license = licenses.mit;
    maintainers = with maintainers; [ mnacamura ];
    platforms = platforms.unix;
  };
}
