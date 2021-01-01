{ stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "oatpp";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "oatpp";
    repo = "oatpp";
    rev = version;
    sha256 = "05rm0m5zf1b5ky8prf6yni2074bz6yjjbrc2qk96fb48fc1198gw";
  };

  nativeBuildInputs = [ cmake ];

  # Tests fail on darwin. See https://github.com/NixOS/nixpkgs/pull/105419#issuecomment-735826894
  doCheck = !stdenv.isDarwin;

  meta = with stdenv.lib; {
    homepage = "https://oatpp.io/";
    description = "Light and powerful C++ web framework for highly scalable and resource-efficient web applications";
    license = licenses.asl20;
    maintainers = [ maintainers.ivar ];
    platforms = platforms.all;
  };
}
