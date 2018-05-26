{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, withVoice ? true, libopus
, asyncio
, aiohttp
, websockets
, pynacl
}:

buildPythonPackage rec {
  pname = "discord.py";
  version = "0.16.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17fb8814100fbaf7a79468baa432184db6cef3bbea4ad194fe297c7407d50108";
  };

  propagatedBuildInputs = [ asyncio aiohttp websockets pynacl ];
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
