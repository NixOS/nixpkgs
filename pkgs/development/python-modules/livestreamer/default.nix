{ lib
, buildPythonPackage
, fetchFromGitHub
, isPyPy
, makeWrapper
, rtmpdump
, pycrypto
, requests
}:

buildPythonPackage rec {
  pname = "livestreamer";
  version = "1.12.2";
  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "chrippa";
    repo = "livestreamer";
    rev = "v${version}";
    hash = "sha256-PqqyBh+oMmu7Ynly3fqx/+6mQYX+6SpI0Okj2O+YLz0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = [ rtmpdump pycrypto requests ];

  postInstall = ''
    wrapProgram $out/bin/livestreamer --prefix PATH : ${lib.makeBinPath [ rtmpdump ]}
  '';

  meta = with lib; {
    homepage = "http://livestreamer.tanuki.se";
    description = "Livestreamer is CLI program that extracts streams from various services and pipes them into a video player of choice";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };

}
