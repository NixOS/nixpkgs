{ lib
, buildPythonPackage
, pkgs
, fetchFromGitHub
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

  src = fetchFromGitHub {
    owner = "chrippa";
    repo = "livestreamer";
    rev = "v1.12.2";
    sha256 = "sha256-PqqyBh+oMmu7Ynly3fqx/+6mQYX+6SpI0Okj2O+YLz0=";
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
