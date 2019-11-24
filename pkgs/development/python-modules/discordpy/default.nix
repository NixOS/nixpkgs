{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, withVoice ? true, libopus
, aiohttp
, websockets
, pynacl
}:

buildPythonPackage rec {
  pname = "discord.py";
  version = "1.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3e044d84f0bb275d173e2d958cb4a579e525707f90e3e8a15c59901f79e80663";
  };

  propagatedBuildInputs = [ aiohttp websockets pynacl ];
  patchPhase = ''
    substituteInPlace "requirements.txt" \
      --replace "aiohttp>=1.0.0,<1.1.0" "aiohttp"
  '' + lib.optionalString withVoice ''
    substituteInPlace "discord/opus.py" \
      --replace "ctypes.util.find_library('opus')" "'${libopus}/lib/libopus.so.0'"
  '';

  disabled = pythonOlder "3.5";

  # No tests in archive
  doCheck = false;

  meta = {
    description = "A python wrapper for the Discord API";
    homepage    = "https://discordpy.rtfd.org/";
    license     = lib.licenses.mit;

    # discord.py requires websockets<4.0
    # See https://github.com/Rapptz/discord.py/issues/973
    broken = true;
  };
}
