{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, withVoice ? true, libopus
, aiohttp
, websockets
, pynacl
}:

buildPythonPackage rec {
  pname = "discord.py";
  version = "1.2.5";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "Rapptz";
    repo = pname;
    rev = "v${version}";
    sha256 = "17l6mlfi9ikqndpmi4pwlvb53g132cycyfm9nzdyiqr96k8ly4ig";
  };

  propagatedBuildInputs = [
    aiohttp
    websockets
  ] ++ lib.optionals withVoice [ pynacl ];

  patchPhase = ''
    substituteInPlace "requirements.txt" \
      --replace "aiohttp>=3.3.0,<3.6.0" "aiohttp" \
      --replace "websockets>=6.0,<7.0" "websockets"
  '' + lib.optionalString withVoice ''
    substituteInPlace "discord/opus.py" \
      --replace "ctypes.util.find_library('opus')" "'${libopus}/lib/libopus.so.0'"
  '';

  # no tests for package...
  doCheck = false;

  meta = with lib; {
    description = "A python wrapper for the Discord API";
    homepage = https://discordpy.rtfd.org/;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
