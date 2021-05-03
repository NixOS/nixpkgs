{ lib
, buildPythonPackage
, pkgs
, isPyPy
, pycrypto
, requests
, singledispatch ? null
, futures ? null
, isPy27
}:

buildPythonPackage rec {
  version = "1.12.2";
  pname = "livestreamer";
  disabled = isPyPy;

  src = pkgs.fetchurl {
    url = "https://github.com/chrippa/livestreamer/archive/v${version}.tar.gz";
    sha256 = "1fp3d3z2grb1ls97smjkraazpxnvajda2d1g1378s6gzmda2jvjd";
  };

  nativeBuildInputs = [ pkgs.makeWrapper ];

  propagatedBuildInputs = [ pkgs.rtmpdump pycrypto requests ]
    ++ lib.optionals isPy27 [ singledispatch futures ];

  postInstall = ''
    wrapProgram $out/bin/livestreamer --prefix PATH : ${pkgs.rtmpdump}/bin
  '';

  meta = with lib; {
    homepage = "http://livestreamer.tanuki.se";
    description = ''
      Livestreamer is CLI program that extracts streams from various
      services and pipes them into a video player of choice.
    '';
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };

}
