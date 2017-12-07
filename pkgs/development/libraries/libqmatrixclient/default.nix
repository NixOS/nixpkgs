{ stdenv, fetchFromGitHub, cmake
, qtbase }:

# This doesn't actually do anything really yet as it doesn't support dynamic building
# When it does, quaternion and tensor should use it

stdenv.mkDerivation rec {
  name = "libqmatrixclient-${version}";
  version = "0.1";

  src = fetchFromGitHub {
    owner  = "QMatrixClient";
    repo   = "libqmatrixclient";
    rev    = "v${version}";
    sha256 = "1dlanf0y65zf6n1b1f4jzw04w07sl85wiw01c3yyn2ivp3clr13l";
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
