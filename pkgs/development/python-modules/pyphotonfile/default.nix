{ lib
, buildPythonPackage
, fetchFromGitHub
, pillow
, numpy
}:
let
  version = "0.2.1";
  format = "setuptools";
in
buildPythonPackage {
  pname = "pyphotonfile";
  inherit version;
  propagatedBuildInputs = [ pillow numpy ];

  src = fetchFromGitHub {
    owner = "fookatchu";
    repo = "pyphotonfile";
    rev = "v${version}";
    sha256 = "1hh1fcn7q3kyk2413pjs18xnxvzrchrisbpj2cd59jrdp0qzgv2s";
  };

  meta = with lib; {
    maintainers = [ maintainers.cab404 ];
    license = licenses.gpl3Plus;
    description = "Library for reading and writing files for the Anycubic Photon 3D-Printer";
    homepage = "https://github.com/fookatchu/pyphotonfile";
  };

}
