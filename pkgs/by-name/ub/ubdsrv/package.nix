{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, liburing }:

stdenv.mkDerivation (finalAttrs: {
  pname = "ubdsrv";
  version = "1.1-rc1";

  src = fetchFromGitHub {
    owner = "ming1";
    repo = "ubdsrv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xY1iWsZKPnri1eZV/L1LWMkNtPERGofoZ1262DdcJWg=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ liburing ];

  doCheck = true;

  meta = with lib; {
    description = "Userspace block device driver";
    homepage = "https://github.com/ming1/ubdsrv";
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres maintainers.lx ];
    license = licenses.mit;
  };
})
