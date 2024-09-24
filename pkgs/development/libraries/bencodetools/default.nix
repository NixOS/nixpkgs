{ stdenv
, lib
, fetchFromGitLab
, python3
}:

stdenv.mkDerivation rec {
  pname = "bencodetools";
  version = "unstable-2022-05-11";

  src = fetchFromGitLab {
    owner = "heikkiorsila";
    repo = "bencodetools";
    rev = "384d78d297a561dddbbd0f4632f0c74c0db41577";
    sha256 = "1d699q9r33hkmmqkbh92ax54mcdf9smscmc0dza2gp4srkhr83qm";
  };

  postPatch = ''
    patchShebangs configure
    substituteInPlace configure \
      --replace 'python_install_option=""' 'python_install_option="--prefix=$out"'
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    python3
  ];

  # installCheck instead of check due to -install_name'd library on Darwin
  doInstallCheck = stdenv.buildPlatform == stdenv.hostPlatform;
  installCheckTarget = "check";

  meta = with lib; {
    description = "Collection of tools for manipulating bencoded data";
    homepage = "https://gitlab.com/heikkiorsila/bencodetools";
    license = licenses.bsd2;
    maintainers = with maintainers; [ OPNA2608 ];
    mainProgram = "bencat";
    platforms = platforms.unix;
  };
}
