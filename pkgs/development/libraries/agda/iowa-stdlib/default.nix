{
  lib,
  mkDerivation,
  fetchFromGitHub,
}:

mkDerivation (rec {
  version = "1.5.0";
  pname = "iowa-stdlib";

  src = fetchFromGitHub {
    owner = "cedille";
    repo = "ial";
    rev = "v${version}";
    sha256 = "0dlis6v6nzbscf713cmwlx8h9n2gxghci8y21qak3hp18gkxdp0g";
  };

  libraryFile = "";
  libraryName = "IAL-1.3";

  buildPhase = ''
    patchShebangs find-deps.sh
    make
  '';

  meta = {
    homepage = "https://github.com/cedille/ial";
    description = "Agda standard library developed at Iowa";
    license = lib.licenses.free;
    platforms = lib.platforms.unix;
    # broken since Agda 2.6.1
    broken = true;
    maintainers = with lib.maintainers; [
      alexarice
      turion
    ];
  };
})
