{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "breakpad-2016-03-28";
  
  src = fetchgit {
    url = "https://chromium.googlesource.com/breakpad/breakpad";
    rev = "512cac3a1b69721ab727f3079f4d29e4580467b1";
    sha256 = "1ksilbdpi1krycxkidqd1dlly95qf7air3zy8h5zfnagrlkz7zzx";
  };

  breakpad_lss = fetchgit {
    url = "https://chromium.googlesource.com/linux-syscall-support";
    rev = "08056836f2b4a5747daff75435d10d649bed22f6";
    sha256 = "1ryshs2nyxwa0kn3rlbnd5b3fhna9vqm560yviddcfgdm2jyg0hz";
  };

  enableParallelBuilding = true;

  prePatch = ''
    cp -r $breakpad_lss src/third_party/lss
    chmod +w -R src/third_party/lss
  '';

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
