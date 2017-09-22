{ lib
, fetchurl
, buildPythonPackage
, pythonOlder
, withVoice ? true, libopus
, asyncio
, aiohttp
, websockets
, pynacl
}:

let
  pname = "discord.py";
  version = "0.16.11";
in buildPythonPackage rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "eb3c6faa7d4570cce05533d0742bbcb768629e2b3ba9e1cc79c05833db91ac4d";
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
  };
}
