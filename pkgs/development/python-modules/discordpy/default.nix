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
  version = "0.16.8";
in buildPythonPackage rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "d775b701383e3a5762accf3816b819f357f299476701615ac30c7715a5ea79aa";
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

  meta = {
    description = "A python wrapper for the Discord API";
    homepage    = "https://discordpy.rtfd.org/";
    license     = lib.licenses.mit;
  };
}
