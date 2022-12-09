{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "sigslot";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "palacaze";
    repo = "sigslot";
    rev = "v${version}";
    hash = "sha256-FXoKI0aTpZNHHYZnEoPduf3ctOQ/qKoQrrXZPviAvuY=";
  };

  nativeBuildInputs = [ cmake ];

  dontBuild = true;

  meta = with lib; {
    description = "A header-only, thread safe implementation of signal-slots for C++";
    license = licenses.mit;
    homepage = "https://github.com/palacaze/sigslot";
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.all;
  };
}
