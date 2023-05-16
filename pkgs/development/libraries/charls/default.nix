{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "charls";
<<<<<<< HEAD
  version = "2.4.2";
=======
  version = "2.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "team-charls";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-c1wrk6JLcAH7TFPwjARlggaKXrAsLWyUQF/3WHlqoqg=";
=======
    hash = "sha256-l0qcJeQfRqpwR7vNmYZx00kGlPkK7nEYuslydjxj7ss=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace src/charls-template.pc  \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@  \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  # note this only runs some basic tests, not the full test suite,
  # but the recommended `charlstest -unittest` fails with an inscrutable C++ IO error
  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/team-charls/charls";
    description = "A JPEG-LS library implementation in C++";
    maintainers = with maintainers; [ bcdarwin ];
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
