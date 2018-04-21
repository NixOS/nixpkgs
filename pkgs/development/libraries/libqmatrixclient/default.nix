{ stdenv, fetchFromGitHub, cmake
, qtbase }:

# This doesn't actually do anything really yet as it doesn't support dynamic building
# When it does, quaternion and tensor should use it

stdenv.mkDerivation rec {
  name = "libqmatrixclient-${version}";
  version = "0.2";

  src = fetchFromGitHub {
    owner  = "QMatrixClient";
    repo   = "libqmatrixclient";
    rev    = "v${version}-q0.0.5";
    sha256 = "1m53yxsqjxv2jq0h1xipwsgaj5rca4fk4cl3azgvmf19l9yn00ck";
  };

  buildInputs = [ qtbase ];

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/lib *.a

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description= "A Qt5 library to write cross-platfrom clients for Matrix";
    homepage = https://matrix.org/docs/projects/sdk/libqmatrixclient.html;
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ peterhoeg ];
    hydraPlatforms = [ ];
  };
}
