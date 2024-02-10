{ lib
, stdenvNoCC
, fetchurl
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "unix-privesc-check";
  version = "1.4";

  src = fetchurl {
    url = "http://pentestmonkey.net/tools/unix-privesc-check/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    hash = "sha256-4fhef2n6ut0jdWo9dqDj2GSyHih2O2DOLmGBKQ0cGWk=";
  };

  installPhase = ''
    install -Dm 755 unix-privesc-check $out/bin/unix-privesc-check
  '';

  meta = with lib; {
    description = "Find misconfigurations that could allow local unprivilged users to escalate privileges to other users or to access local apps";
    mainProgram = "unix-privesc-check";
    homepage = "http://pentestmonkey.net/tools/audit/unix-privesc-check";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
  };
})
