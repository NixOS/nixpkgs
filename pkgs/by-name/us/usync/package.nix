{
  lib,
  stdenv,
  fetchFromGitHub,
  scsh,
  rsync,
  unison,
}:

stdenv.mkDerivation rec {
  pname = "usync";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "ebzzry";
    repo = "usync";
    rev = "99f11b0c196a81843f55ca3456abcb85149b6d51";
    sha256 = "16i1q8f0jmfd43rb8d70l2b383vr5ib4kh7iq3yd345q7xjz9c2j";
  };

  installPhase = ''
    install -m 555 -Dt $out/bin $pname
  '';

  postFixup = ''
    substituteInPlace $out/bin/$pname --replace "/usr/bin/env scsh" "${scsh}/bin/scsh"
    substituteInPlace $out/bin/$pname --replace "(rsync " "(${rsync}/bin/rsync "
    substituteInPlace $out/bin/$pname --replace "(unison " "(${unison}/bin/unison "
  '';

  meta = with lib; {
    homepage = "https://github.com/ebzzry/usync";
    description = "Simple site-to-site synchronization tool";
    license = licenses.mit;
    maintainers = [ maintainers.ebzzry ];
    platforms = platforms.unix;
    mainProgram = "usync";
  };

  dontBuild = true;
}
