{ lib
, stdenv
, fetchFromGitHub
, cmake
, nodejs
}:

stdenv.mkDerivation rec {
  pname = "llhttp";
  version = "8.1.0";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7qBr7R4sU0AjPXqSdeQ5dq+HbXWt+gihvHfF5eXAA7M=";
  };

  nativeBuildInputs = [ cmake nodejs ];

  cmakeFlags = [
    "-S ../release"
    "-DBUILD_SHARED_LIBS=ON"
  ];

  postPatch = ''
    export HOME=$(mktemp -d)
    npm install
    make release RELEASE=${version}
  '';

  meta = with lib; {
    description = "Port of http_parser to llparse";
    homepage = "https://llhttp.org";
    license = licenses.mit;
    maintainers = with maintainers; [ candyc1oud ];
    platforms = platforms.unix;
  };
}
