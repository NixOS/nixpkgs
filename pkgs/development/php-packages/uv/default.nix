{
  buildPecl,
  lib,
  fetchFromGitHub,
  libuv,
}:

buildPecl rec {
  pname = "uv";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "amphp";
    repo = "ext-uv";
    rev = "v${version}";
    hash = "sha256-RYb7rszHbdTLfBi66o9hVkFwX+7RlcxH5PAw5frjpFg=";
  };

  buildInputs = [ libuv ];

  meta = with lib; {
    description = "Interface to libuv for php";
    license = licenses.php301;
    homepage = "https://github.com/amphp/ext-uv";
    maintainers = teams.php.members;
    platforms = platforms.linux;
  };
}
