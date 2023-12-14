{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pytestCheckHook
, stdenv
, darwin
}:

buildPythonPackage rec {
  pname = "aubio";
  version = "0.4.9";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0fhxikvlr010nbh02g455d5y8bq6j5yw180cdh4gsd0hb43y3z26";
  };

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ Accelerate AudioToolbox CoreVideo CoreGraphics ]);

  propagatedBuildInputs = [
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aubio" ];

  meta = with lib; {
    description = "a library for audio and music analysis";
    homepage = "https://aubio.org";
    license = licenses.gpl3;
    maintainers = with maintainers; [ hexa ];
  };
}
