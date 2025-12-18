{
  lib,
  stdenv,
  fetchFromGitHub,
  scsh,
  rsync,
  unison,
}:

stdenv.mkDerivation {
  pname = "usync";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "ebzzry";
    repo = "usync";
    rev = "2d6003afceeccb73114caa25f84e48b300430f0c";
    hash = "sha256-UrD0ZT+4kNH8wPHASVYseQ80lqDgNLTyIM1VCRzCIZo=";
  };

  installPhase = ''
    install -m 555 -Dt $out/bin $pname
  '';

  postFixup = ''
    substituteInPlace $out/bin/$pname --replace "/usr/bin/env scsh" "${scsh}/bin/scsh"
    substituteInPlace $out/bin/$pname --replace "(rsync " "(${rsync}/bin/rsync "
    substituteInPlace $out/bin/$pname --replace "(unison " "(${unison}/bin/unison "
  '';

  meta = {
    homepage = "https://github.com/ebzzry/usync";
    description = "Simple site-to-site synchronization tool";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ebzzry ];
    platforms = lib.platforms.unix;
    mainProgram = "usync";
  };

  dontBuild = true;
}
