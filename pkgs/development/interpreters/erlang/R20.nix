{ mkDerivation }:

mkDerivation {
  version = "20.3.8.9";
  sha256 = "0v2iiyzss8hiih98wvj0gi2qzdmmhh7bvc9p025wlfm4k7r1109a";

  prePatch = ''
    substituteInPlace configure.in --replace '`sw_vers -productVersion`' "''${MACOSX_DEPLOYMENT_TARGET:-10.12}"
  '';
}
