let version = "2.9.7"; in
{ stdenv, lib, buildPackages, fetchurl, zlib, gettext
, wordlists ? [ (fetchurl {
  url = "https://github.com/cracklib/cracklib/releases/download/v${version}/cracklib-words-${version}.gz";
  sha256 = "12fk8w06q628v754l357cf8kfjna98wj09qybpqr892az3x4a33z";
}) ]
}:

stdenv.mkDerivation rec {
  pname = "cracklib";
  inherit version;

  src = fetchurl {
    url = "https://github.com/${pname}/${pname}/releases/download/v${version}/${pname}-${version}.tar.bz2";
    sha256 = "1rimpjsdnmw8f5b7k558cic41p2qy2n2yrlqp5vh7mp4162hk0py";
  };

  nativeBuildInputs = lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) buildPackages.cracklib;
  buildInputs = [ zlib gettext ];

  postPatch = ''
    chmod +x util/cracklib-format
    patchShebangs util

    ln -vs ${toString wordlists} dicts/
  '';

  postInstall = ''
    make dict-local
  '';
  doInstallCheck = true;
  installCheckTarget = "test";

  meta = with lib; {
    homepage    = https://github.com/cracklib/cracklib;
    description = "A library for checking the strength of passwords";
    license = licenses.lgpl21; # Different license for the wordlist: http://www.openwall.com/wordlists
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
