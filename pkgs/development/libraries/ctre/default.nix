{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "ctre";
<<<<<<< HEAD
  version = "3.8";
=======
  version = "3.7.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "hanickadot";
    repo = "compile-time-regular-expressions";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-oGJHSyvcgvBJh5fquK6dU70czVg4txcGTuicvrTK2hc=";
=======
    hash = "sha256-pO6PW4oZsCA2xaMCsaJz2Bu203zyMUkbjO3OOBEbSiw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    substituteInPlace packaging/pkgconfig.pc.in \
      --replace "\''${prefix}/" ""
  '';

  dontBuild = true;

  meta = with lib; {
    description = "Fast compile-time regular expressions library";
    longDescription = ''
      Fast compile-time regular expressions with support for
      matching/searching/capturing during compile-time or runtime.
    '';
    license = licenses.asl20;
    homepage = "https://compile-time.re";
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.all;
  };
}
