{ lib, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "oatpp";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "oatpp";
    repo = "oatpp";
    rev = version;
    sha256 = "sha256-Vtdz03scx0hvY1yeM7yfSxCVKzi84OQ1Oh9b922movE=";
  };

  nativeBuildInputs = [ cmake ];

  # Tests fail on darwin. See https://github.com/NixOS/nixpkgs/pull/105419#issuecomment-735826894
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    homepage = "https://oatpp.io/";
    description = "Light and powerful C++ web framework for highly scalable and resource-efficient web applications";
    license = licenses.asl20;
    maintainers = [ maintainers.ivar ];
    platforms = platforms.all;
  };
}
