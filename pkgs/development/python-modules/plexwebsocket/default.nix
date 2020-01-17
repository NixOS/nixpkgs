{ lib, buildPythonPackage, fetchPypi, aiohttp }:

buildPythonPackage rec {
  pname = "plexwebsocket";
  version = "0.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1sp1ky6sy0d23h71sl3zkvy7vlif1rs8w51dlh3n8q9c44px42h0";
  };

  propagatedBuildInputs = [ aiohttp ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/jjlawren/python-plexwebsocket/";
    description = "Async library to react to events issued over Plex websockets";
    license = licenses.mit;
    maintainers = with maintainers; [ colemickens ];
  };
}
