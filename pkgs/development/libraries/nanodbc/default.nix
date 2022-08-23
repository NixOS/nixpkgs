{ lib, stdenv, fetchFromGitHub, cmake, unixODBC }:

stdenv.mkDerivation rec {
  pname = "nanodbc";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "nanodbc";
    repo = "nanodbc";
    rev = "v${version}";
    sha256 = "1q80p7yv9mcl4hyvnvcjdr70y8nc940ypf368lp97vpqn5yckkgm";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ unixODBC ];

  cmakeFlags = if (stdenv.hostPlatform.isStatic) then
    [ "-DBUILD_STATIC_LIBS=ON" ]
  else
    [ "-DBUILD_SHARED_LIBS=ON" ];

  # fix compilation on macOS
  # https://github.com/nanodbc/nanodbc/issues/274
  # remove after the next version update
  postUnpack = if stdenv.isDarwin then ''
    mv $sourceRoot/VERSION $sourceRoot/VERSION.txt
    substituteInPlace $sourceRoot/CMakeLists.txt \
       --replace 'file(STRINGS VERSION' 'file(STRINGS VERSION.txt'
  '' else "";

  meta = with lib; {
    homepage = "https://github.com/nanodbc/nanodbc";
    changelog = "https://github.com/nanodbc/nanodbc/raw/v${version}/CHANGELOG.md";
    description = "Small C++ wrapper for the native C ODBC API";
    license = licenses.mit;
    maintainers = [ maintainers.bzizou ];
  };
}
