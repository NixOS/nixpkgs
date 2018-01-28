{ lib
, python
, withVoice ? true, libopus
}:

let
  py = python.override {
    packageOverrides = self: super: {
      websockets = super.websockets.overridePythonAttrs (oldAttrs: rec {
        version = "3.4";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "1idwcdxd36q7ks5w1yjgg15d2sw81kg2lvk4dx60l06h3psvkra3";
        };
      });
    };
  };

in with py.pkgs; buildPythonPackage rec {
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
  };
}
