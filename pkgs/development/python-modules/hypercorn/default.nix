{ lib
, buildPythonPackage
, fetchPypi
, isPy27, isPy35, isPy36
, pythonOlder
, typing-extensions
, wsproto
, toml
, h2
, priority
}:

buildPythonPackage rec {
  pname = "Hypercorn";
  version = "0.11.2";
  disabled = isPy27 || isPy35 || isPy36;

  src = fetchPypi {
    inherit pname version;
    sha256 = "5ba1e719c521080abd698ff5781a2331e34ef50fc1c89a50960538115a896a9a";
  };

  propagatedBuildInputs = [ wsproto toml h2 priority ]
  ++ lib.optionals (pythonOlder "3.8") [ typing-extensions ];

  doCheck = false;

  pythonImportsCheck = [ "hypercorn" ];

  meta = with lib; {
    homepage = "https://pgjones.gitlab.io/hypercorn/";
    description = "The ASGI web server inspired by Gunicorn";
    license = licenses.mit;
  };
}
