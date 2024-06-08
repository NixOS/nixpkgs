{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  nose,
  minimock,
}:

buildPythonPackage rec {
  pname = "mypgoclient";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "gpodder";
    repo = "mygpoclient";
    rev = version;
    sha256 = "0aa28wc55x3rxa7clwfv5v5500ffyaq0vkxaa3v01y1r93dxkdvp";
  };

  nativeCheckInputs = [
    nose
    minimock
  ];

  checkPhase = ''
    nosetests
  '';

  doCheck = (!stdenv.isDarwin);

  meta = with lib; {
    description = "A gpodder.net client library";
    longDescription = ''
      The mygpoclient library allows developers to utilize a Pythonic interface
      to the gpodder.net web services.
    '';
    homepage = "https://github.com/gpodder/mygpoclient";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ ];
  };
}
