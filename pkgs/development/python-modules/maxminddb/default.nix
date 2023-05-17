{ stdenv
, lib
, buildPythonPackage
, pythonOlder
, pythonAtLeast
, fetchPypi
, libmaxminddb
, mock
, nose
}:

buildPythonPackage rec {
  pname = "maxminddb";
  version = "2.3.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Egkg3d2VXzKuSMIHxs72/V3Ih0qIm6lLDywfc27N8wg=";
  };

  buildInputs = [ libmaxminddb ];

  nativeCheckInputs = [ nose mock ];

  # Tests are broken for macOS on python38
  doCheck = !(stdenv.isDarwin && pythonAtLeast "3.8");

  meta = with lib; {
    description = "Reader for the MaxMind DB format";
    homepage = "https://github.com/maxmind/MaxMind-DB-Reader-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
