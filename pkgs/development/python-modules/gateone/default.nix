{ stdenv
, buildPythonPackage
, tornado
, futures
, html5lib
, pkgs
, isPy3k
}:

buildPythonPackage {
  name = "gateone-1.2-0d57c3";
  disabled = isPy3k;

  src = pkgs.fetchFromGitHub {
    rev = "1d0e8037fbfb7c270f3710ce24154e24b7031bea";
    owner= "liftoff";
    repo = "GateOne";
    sha256 = "1ghrawlqwv7wnck6alqpbwy9mpv0y21cw2jirrvsxaracmvgk6vv";
  };

  propagatedBuildInputs = [tornado futures html5lib pkgs.openssl pkgs.cacert pkgs.openssh];

  postInstall=''
    cp -R "$out/gateone/"* $out/lib/python2.7/site-packages/gateone
  '';

  meta = with stdenv.lib; {
    homepage = "http://liftoffsoftware.com/";
    description = "GateOne is a web-based terminal emulator and SSH client";
    maintainers = with maintainers; [ tomberek ];
    license = licenses.gpl3;
  };

}
